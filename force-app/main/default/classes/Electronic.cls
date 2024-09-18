public class Electronic extends Product {
     
    public String warrantyPeriod;
    public String brand;
    
    public Electronic(String name, Integer quantity, Decimal pricePerUnit, String warrantyPeriod, String brand) {
        super(name, quantity, pricePerUnit);
        this.warrantyPeriod = warrantyPeriod;
        this.brand = brand;
    }
    
    
    public override Decimal calculateValue(){
        Decimal value = super.calculateValue();
        if (quantity > 10) {
            value = value * 0.9;
        }
        return value;
    }
}