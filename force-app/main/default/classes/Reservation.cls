public abstract class Reservation {
    public String reservationId;
    public Date reservationDate;
    public Decimal cost;

    public Reservation(String reservationId, Date reservationDate, Decimal cost){
        this.reservationId = reservationId;
        this.reservationDate = reservationDate;
        this.cost = cost;
    }
    
    public abstract String getReservationType();
    public abstract Boolean validateReservation();
    
    public void applyDiscount(Decimal discountPercentage){
         cost -= cost * (discountPercentage / 100);
    }
    
    public virtual String getReservationDetails(){
        return 'Reservation ID: ' + reservationId + ', Date: ' + reservationDate + ', Cost: ' + cost;
    }
}