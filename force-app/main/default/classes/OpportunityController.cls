public class OpportunityController {
    
    public List<Opportunity> opportunities { get; set; }
    public Integer totalRecords { get; set; }
    public Integer pageSize { get; set; }
    public Integer currentPage { get; set; }
    
    public OpportunityController(){
        pageSize = 5;
        currentPage = 1;
        loadOpportunities();
    }    
    
    public void nextPage() {
        if (currentPage < (totalRecords + pageSize - 1) / pageSize) {
            currentPage++;
            loadOpportunities();
        }
    }
    
    public void previousPage() {
        if (currentPage > 1) {
            currentPage--;
            loadOpportunities();
        }
    }
    
    private void loadOpportunities(){
        opportunities = [SELECT Id, Name, Amount, CloseDate FROM Opportunity LIMIT :pageSize OFFSET :((currentPage - 1) * pageSize)];   
        totalRecords = opportunities.size();        
    }
}