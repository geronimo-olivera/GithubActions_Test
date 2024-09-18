public class InventoryManager {
    
    private List<InventoryItem> items = new List<InventoryItem>();

    public void addItem(InventoryItem item){
        this.items.add(item);
    }
    
    public Decimal calculateTotalInventoryValue(){
        Decimal value = 0;
        for(InventoryItem item: this.items){
            value = value + (item.calculateValue());
        }
        
        return value;
    }
}