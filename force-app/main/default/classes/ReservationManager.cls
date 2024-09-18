public class ReservationManager {
    public List<Reservation> reservations = new List<Reservation>();
    
    public void addReservation(Reservation reservation) {
        this.reservations.add(reservation);
    }
    
    public Boolean validateAllReservations() {
        for(Reservation reservation : reservations){
            if(!reservation.validateReservation()){
                throw new InvalidReservationException('Invalid reservation found: ' + reservation.getReservationDetails());
            }
        }
        return true;
    }
    
    public Decimal calculateTotalRevenue() {
        Decimal value = 0;
        for(Reservation reservation : reservations) {
            value = value + reservation.cost;
        }
        return value;
    }
    
    public List<String> getAllReservationsOfType(String type){
        List<String> reservationDetails = new List<String>();
        for (Reservation reservation : reservations) {
            if (reservation.getReservationType() == type) {
                reservationDetails.add(reservation.getReservationDetails());
            }
        }
        return reservationDetails;
    }
}