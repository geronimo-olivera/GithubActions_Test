public class CompareStringUtil {
    String firstValue = null;
    String secondValue = null;
    public Boolean result = false;

    public CompareStringUtil(String valueOne, String valueTwo, String operator) {
        firstValue = convertValue(valueOne);
        secondValue = convertValue(valueTwo);
        result = compare(firstValue, secondValue, operator);
    } 

    private String convertValue(String value) {
        if (String.valueOf(value) == 'null' || value == null) {
            return null;
        }

        return String.valueOf(value);
    }

    private Boolean compare(String firstValue, String secondValue, String operator) {
        Boolean stringComparision = false;
        switch on operator {
            when '==' {
                stringComparision = firstValue == secondValue;
            }
            when '!=' {
                stringComparision = firstValue != secondValue;
            }
            when else {
                stringComparision = false;
            }
        }
        return stringComparision;
    }
}