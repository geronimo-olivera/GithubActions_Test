public class ValidationRuleManager {
    private static Map<String, Schema.SObjectField> fieldsMap;

    public static void handle(String objectName) {
        if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
            fieldsMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            List<Validation_Rule_Setting__mdt> validationRuleSettingsByObjectName = getValidationRuleSettingsByObjectName(objectName);
            
            if(!validationRuleSettingsByObjectName.isEmpty()){                              
                for (Validation_Rule_Setting__mdt vrSetting : validationRuleSettingsByObjectName) {
                    if(checkContextToRunValidations(vrSetting)){
                        if (vrSetting.Error_Message__c != null && vrSetting.Criteria__c != null) {
                            String errorMessage = String.valueOf(vrSetting.Error_Message__c);
                            for (SObject obj : Trigger.new) {
                                Boolean validationShouldDisplay = validationShouldDisplay(objectName, obj, String.valueOf(vrSetting.Criteria__c));
                                if (validationShouldDisplay) {
                                    String fieldToDisplayError = String.valueOf(vrSetting.Field__c);
                                    if (String.isNotBlank(fieldToDisplayError)) {
                                        if(fieldsMap.containsKey(fieldToDisplayError)){
                                            obj.addError(fieldToDisplayError, errorMessage);
                                        } else {
                                            obj.addError(errorMessage);
                                        }                                        
                                    } else {
                                        obj.addError(errorMessage);
                                    }                            
                                }
                            }
                        }
                    }
                }
            }
        }
    }    
    
    /**
     * Get Validation Rule Setting metadatada by object.
     * @param objectName api name of the object.
     * @return a list of Validation Rule Setting metadatada records.
     */
    private static List<Validation_Rule_Setting__mdt> getValidationRuleSettingsByObjectName(String objectName) {
        return [
            SELECT Field__c, Error_Message__c, Criteria__c, Object__c, Is_Insert__c, Is_Update__c
            FROM Validation_Rule_Setting__mdt
            WHERE Object__c = :objectName AND Is_Active__c = TRUE
        ];
    }
    
    /**
     * Check in what trigger context is executed and compare with the metadata record.
     * @param vrSetting Validation Rule Setting metadatada record.
     * @return a Boolean if the trigger context is the same as the validation context.
     */
    private static Boolean checkContextToRunValidations(Validation_Rule_Setting__mdt vrSetting) {
        Boolean isInsert = Trigger.isInsert;
        Boolean isUpdate = Trigger.isUpdate;
        Boolean isInsertSetting = Boolean.valueOf(vrSetting.Is_Insert__c);
        Boolean isUpdateSetting = Boolean.valueOf(vrSetting.Is_Update__c);
        
        Boolean shouldRunInsertValidation = isInsert && isInsertSetting && !isUpdateSetting;
        Boolean shouldRunUpdateValidation = isUpdate && isUpdateSetting && !isInsertSetting;
        Boolean shouldRunBothValidations = isInsertSetting && isUpdateSetting;
        
        return shouldRunInsertValidation || shouldRunUpdateValidation || shouldRunBothValidations;
    }

    /**
     * Check if validation in the metadata should be displayed compare with the record triggered.
     * @param objectName objectName api name of the object.
     * @param obj record triggered.
     * @param validationCriteria criteria of the Validation Rule Setting metadatada record.
     * @return a Boolean if validation in the metadata should be displayed compare with the record triggered.
     */
    private static Boolean validationShouldDisplay(String objectName, SObject obj, String validationCriteria) {
        Boolean validationShouldDisplay = false;
        List<String> orCriteriaList = getCriteriaSplittedByLogicalOperator(validationCriteria, 'OR');
        if (orCriteriaList != null) {
            for (String orCriteria : orCriteriaList) {
                List<String> andCriteriaList = getCriteriaSplittedByLogicalOperator(orCriteria, 'AND');
                if (andCriteriaList != null) {
                    for (String andCriteria : andCriteriaList) {
                        validationShouldDisplay = isRecordMatchedWithValidationCriteria(objectName, obj, andCriteria);
                        if (!validationShouldDisplay) {
                            break;
                        }
                    }
                } else {
                    validationShouldDisplay = isRecordMatchedWithValidationCriteria(objectName, obj, orCriteria);
                }

                if (validationShouldDisplay) {
                    break;
                }
            }
        } else {
            List<String> andCriteriaList = getCriteriaSplittedByLogicalOperator(validationCriteria, 'AND');

            if (andCriteriaList != null) {
                for (String andCriteria : andCriteriaList) {
                    validationShouldDisplay = isRecordMatchedWithValidationCriteria(objectName, obj, andCriteria);
                    if (!validationShouldDisplay) {
                        break;
                    }
                }
            } else {
                validationShouldDisplay = isRecordMatchedWithValidationCriteria(objectName, obj, validationCriteria);
            }
        }

        return validationShouldDisplay;
    }

    /**
     * Check if criteria from validation in the metadata is matched with the record.
     * @param objectName objectName api name of the object.
     * @param obj record triggered.
     * @param validationCriteria criteria of the Validation Rule Setting metadatada record.
     * @return a Boolean if criteria from validation in the metadata is matched with the record.
     */
    private static Boolean isRecordMatchedWithValidationCriteria(String objectName, SObject obj, String validationCriteria) {
        String validationCriteriaWhitoutBrackets = removeBracketsFromCriteria(validationCriteria);
        String operator = getOperator(validationCriteria);
        
        if (String.isNotBlank(operator)) {
            List<String> criteriaParts = getCriteriaSplittedByLogicalOperator(validationCriteriaWhitoutBrackets, operator);
            if (criteriaParts.size() == 2) {
                String fieldNameInCriteria = criteriaParts[0].trim();
                String valueOfFieldInCriteria = removeSingleQuotes(criteriaParts[1].trim());
                
                if (fieldNameInCriteria.equals('RecordType.Name')) {
                    return checkRecordType(obj, objectName, operator, valueOfFieldInCriteria);
                } else {
                    String recordFieldValue = String.valueOf(obj.get(fieldNameInCriteria));                   
                    Schema.DisplayType fieldDataType = obj.getSObjectType().getDescribe().fields.getMap().get(fieldNameInCriteria).getDescribe().getType();                    
                    Schema.SObjectField field = fieldsMap.get(valueOfFieldInCriteria);
                    
                    if (field != null) {
                        valueOfFieldInCriteria = String.valueOf(obj.get(valueOfFieldInCriteria));
                    }
                    
                    return compareFieldValues(fieldDataType, recordFieldValue, valueOfFieldInCriteria, operator);
                }
            }
        }
        return false;
    }

    /**
     * Split the criteria by logical operator passed by parameter.
     * @param criteria criteria coming from the metadata.
     * @param logicalOperator operator to split the criteria.
     * @return a list of strings, the criteria splitted by the logical operator passed by parameter.
     */
    private static List<String> getCriteriaSplittedByLogicalOperator(String criteria, String logicalOperator) {
        if (criteria.contains(logicalOperator)) {
            return criteria.trim().split(logicalOperator);
        }
        return null;
    }

    /**
     * Remove brackets from the criteria.
     * @param criteria criteria coming from the metadata with brackets.
     * @return a string whitout brackets.
     */
    private static String removeBracketsFromCriteria(String criteria) {
        criteria = criteria.replace('[', '');
        criteria = criteria.replace(']', '');
        return criteria;
    }

    /**
     * Method to get the Logical Operator in the Criteria from the Metadata.
     * @param criteria decline criteria from the metadata.
     * @return a string that will be the logical operator.
     */
    private static String getOperator(String criteria) {
        if (criteria.contains('==')) {
            return '==';
        } else if (criteria.contains('!=')) {
            return '!=';
        } else if (criteria.contains('<=')) {
            return '<=';
        } else if (criteria.contains('>=')) {
            return '>=';
        } else if (criteria.contains('<')) {
            return '<';
        } else if (criteria.contains('>')) {
            return '>';
        }
        return null;
    }

    /**
     * Remove single quotes.
     * @param value value coming from the metadata.
     * @return a string whitout single quotes.
     */
    private static String removeSingleQuotes(String value) {
        value = value.replace('\'', '');
        return value;
    }

    /**
     * Check the Record Type from the record and from metadata.
     * @param obj SObject record.
     * @param objectName object name.
     * @param operator logical operator.
     * @param valueOfFieldInCriteria value of the record type from the metadata.
     * @return a boolean if the record type coming from the metadata is equal to the record type of the SObject
     */
    private static Boolean checkRecordType(SObject obj, String objectName, String operator, String valueOfFieldInCriteria) {
        String recordTypeId = getRecordTypeIdByDeveloperName(objectName, valueOfFieldInCriteria);
        String recordTypeIdInRecord = String.valueOf(obj.get('RecordTypeId'));
        CompareStringUtil compareRecordType = new CompareStringUtil(recordTypeIdInRecord, recordTypeId, operator);
        return compareRecordType.result;
    }

    /**
     * Method that returns the Id of Record Type based on given developer name.
     * @param objectApiName api object name.
     * @param recordTypeDeveloperName api name of the record type.
     * @return the id of the record type.
     */
    private static Id getRecordTypeIdByDeveloperName(String objectApiName, String recordTypeDeveloperName) {
        return Schema.getGlobalDescribe().get(objectApiName).getDescribe().getRecordTypeInfosByName().get(recordTypeDeveloperName).getRecordTypeId();
    }

    /**
     * Check if the string contains only numbers.
     * @param input value of the field from the metadata.
     * @return a boolean if the string contains only numbers.
     */
    private static Boolean containsOnlyNumbers(String input) {
        if (String.isBlank(input)) {
            return false;
        }

        Pattern pattern = Pattern.compile('^[0-9]+$');
        Matcher matcher = pattern.matcher(input);

        return matcher.matches();
    }

    /**
     * Check if the multiselect picklist field from the metadata has the same value of the field of the record.
     * @param valueOfFieldInCriteria value of the field from the metadata.
     * @param recordFieldValue multiselect picklist value from the record.
     * @param operator logical operator.
     * @return a boolean if the multiselect picklist field from the metadata has the same value of the field of the record.
     */
    private static Boolean checkMultiselectPicklist(String recordFieldValue, String valueOfFieldInCriteria, String operator) {
        if (valueOfFieldInCriteria.equals('null')) {
            return (operator.equals('==') && String.isBlank(recordFieldValue)) || (operator.equals('!=') && String.isNotBlank(recordFieldValue));
        }

        return String.isNotBlank(recordFieldValue) &&
            ((operator.equals('==') && recordFieldValue.split(';').contains(valueOfFieldInCriteria)) || (operator.equals('!=') && !recordFieldValue.split(';').contains(valueOfFieldInCriteria)));
    }

    /**
     * Compares field values of an SObject based on their DisplayType.
     * @param fieldDataType the type of field.
     * @param recordFieldValue value of the field on the record.
     * @param valueOfFieldInCriteria value from the metadata.
     * @param operator logical operator.
     * @return true if the values meet the specified condition; otherwise, false.
     */
    private static Boolean compareFieldValues(Schema.DisplayType fieldDataType, String recordFieldValue, String valueOfFieldInCriteria, String operator) {
        switch on fieldDataType {
            when Integer, Currency, Percent {
                return new CompareNumberUtil(recordFieldValue, valueOfFieldInCriteria, operator).result;
            }
            when Date, DateTime {
                return new CompareDateUtil(recordFieldValue, valueOfFieldInCriteria, operator).result;
            }
            when MultiPicklist {
                return checkMultiselectPicklist(recordFieldValue, valueOfFieldInCriteria, operator);
            }
            when else {
                if (containsOnlyNumbers(recordFieldValue) && containsOnlyNumbers(valueOfFieldInCriteria)) {
                    return new CompareNumberUtil(recordFieldValue, valueOfFieldInCriteria, operator).result;
                } else {
                    return new CompareStringUtil(recordFieldValue, valueOfFieldInCriteria, operator).result;
                }
            }
        }
    }
}