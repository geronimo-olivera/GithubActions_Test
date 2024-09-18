public class Furniture extends Product {
    public String material;
    public Boolean requiresAssembly;
    
    public Furniture(String name, Integer quantity, Decimal pricePerUnit, String material, Boolean requiresAssembly) {
        super(name, quantity, pricePerUnit);
        this.material = material;
        this.requiresAssembly = requiresAssembly;
    }
    
    public override Decimal calculateValue(){
        Decimal value = super.calculateValue();
        if(requiresAssembly){
            value = value * 1.05;
        }
        return value;
    }
}