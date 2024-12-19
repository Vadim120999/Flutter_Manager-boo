   import 'package:scoped_model/scoped_model.dart';

   class Appointment {
     String title;
     DateTime date;

     Appointment({required this.title, required this.date});
   }

   class AppointmentsModel extends Model {
     List<Appointment> _appointments = [];

     List<Appointment> get appointments => List.unmodifiable(_appointments);

  set entityBeingEdited(Null entityBeingEdited) {}

     void addAppointment(Appointment appointment) {
       _appointments.add(appointment);
       notifyListeners();
     }
   }
