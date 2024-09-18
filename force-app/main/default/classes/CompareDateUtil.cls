public class CompareDateUtil {
    Date firstValue = null;
    Date secondValue = null;
    public Boolean result = false;

    public CompareDateUtil(String valueOne, String valueTwo, String operator) {
        firstValue = convertValue(valueOne);
        secondValue = convertValue(valueTwo);
        result = compare(firstValue, secondValue, operator);
    }

    private Date convertValue(String value) {
        if (String.valueOf(value) == 'null' || value == null) {
            return null;
        }

        return Date.valueOf(value);
    }

    private Boolean compare(Date firstValue, Date secondValue, String operator) {
        Boolean dateComparision = false;
        switch on operator {
            when '==' {
                dateComparision = firstValue == secondValue;
            }
            when '!=' {
                dateComparision = firstValue != secondValue;
            }
            when '>' {
                dateComparision = firstValue > secondValue;
            }
            when '<' {
                dateComparision = firstValue < secondValue;
            }
            when '>=' {
                dateComparision = firstValue >= secondValue;
            }
            when '<=' {
                dateComparision = firstValue <= secondValue;
            }
            when else {
                dateComparision = false;
            }
        }
        return dateComparision;
    }
}