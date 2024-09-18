public class HotelReservation extends Reservation {
	public String hotelName;
    public Integer numberOfNights;
    
    public HotelReservation(String reservationId, Date reservationDate, Decimal cost, String hotelName, Integer numberOfNights){
        super(reservationId, reservationDate, cost);
        this.hotelName = hotelName;
        this.numberOfNights = numberOfNights;
    }
    
    public override String getReservationType() {
        return 'Hotel';
    }
    
    public override Boolean validateReservation() {
        return cost > 0 && numberOfNights > 0;
    }
    
    public virtual Decimal calculateTotalCost() {
        return cost * numberOfNights;
    }
}