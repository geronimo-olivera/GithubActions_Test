public class CompareNumberUtil {
    Decimal firstValue = null;
    Decimal secondValue = null;
    public Boolean result = false;

    public CompareNumberUtil(String valueOne, String valueTwo, String operator) {
        firstValue = convertValue(valueOne);
        secondValue = convertValue(valueTwo);
        result = compare(firstValue, secondValue, operator);
    }

    private Decimal convertValue(String value) {
        if (String.valueOf(value) == 'null' || value == null) {
            return null;
        }

        return Decimal.valueOf(value);
    }

    private Boolean compare(Decimal firstValue, Decimal secondValue, String operator) {
        Boolean decimalComparision = false;
        switch on operator {
            when '==' {
                decimalComparision = firstValue == secondValue;
            }
            when '!=' {
                decimalComparision = firstValue != secondValue;
            }
            when '>' {
                decimalComparision = firstValue > secondValue;
            }
            when '<' {
                decimalComparision = firstValue < secondValue;
            }
            when '>=' {
                decimalComparision = firstValue >= secondValue;
            }
            when '<=' {
                decimalComparision = firstValue <= secondValue;
            }
            when else {
                decimalComparision = false;
            }
        }
        return decimalComparision;
    }
}