public virtual class FlightReservation extends Reservation {
    public String flightNumber;
    public String seatClass;
    
    public FlightReservation(String reservationId, Date reservationDate, Decimal cost, String flightNumber, String seatClass){
        super(reservationId, reservationDate, cost);
        this.flightNumber = flightNumber;
        this.seatClass = seatClass;
    }
    
    public override String getReservationType() {
        return 'Flight';
    }
    
    public override Boolean validateReservation() {
        return cost > 0;
    }
    
    public virtual Decimal calculateTotalCost() {
        Decimal additionalCharge = 0;
        if (seatClass == 'Business') {
            additionalCharge = 50;
        } else if (seatClass == 'First') {
            additionalCharge = 100;
        }
        return cost + additionalCharge;
    }
    
    public override String getReservationDetails() {
        return super.getReservationDetails() + ', Flight Number: ' + flightNumber + ', Seat Class: ' + seatClass;
    }
}