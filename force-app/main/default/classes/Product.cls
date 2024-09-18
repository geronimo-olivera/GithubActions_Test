public abstract class Product implements InventoryItem {
    public String name;
    public Integer quantity;
    public Decimal pricePerUnit;
    
    public Product() {
        this.name = 'Test Name';
        this.quantity = 1;
        this.pricePerUnit = 2.0;
    }
    
    public Product(String name, Integer quantity, Decimal pricePerUnit){
        this.name = name;
        this.quantity = quantity;
        this.pricePerUnit = pricePerUnit;
    }
    
    public virtual Decimal calculateValue(){
        return this.quantity * this.pricePerUnit;
    }
}