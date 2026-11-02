from django.db import models

class LoginTable(models.Model):
    username = models.CharField(max_length=30)
    password = models.CharField(max_length=30)
    type = models.CharField(max_length=20)

class HospitalTable(models.Model):
    LOGINID = models.ForeignKey(LoginTable, on_delete=models.CASCADE)
    NAME = models.CharField(max_length=100)
    PLACE = models.CharField(max_length=25)
    POST = models.CharField(max_length=100)
    PIN = models.IntegerField()
    PHONE = models.CharField(max_length=20)
    EMAIL = models.CharField(max_length=30)
    photo = models.FileField()
    latitude = models.FloatField()
    longitude = models.FloatField()

class DepartmentTable(models.Model):
    Name = models.CharField(max_length=30)
    Details = models.CharField(max_length=30)

class DoctorTable(models.Model):
    LOGINID = models.ForeignKey(LoginTable, on_delete=models.CASCADE)
    HospitalID = models.ForeignKey(HospitalTable, on_delete=models.CASCADE)
    Name = models.CharField(max_length=30)
    DepartmentID= models.ForeignKey(DepartmentTable,on_delete=models.CASCADE)
    Age = models.IntegerField()
    Experience = models.CharField(max_length=30)
    PHONE = models.BigIntegerField()
    EMAIL = models.CharField(max_length=30)
    photo = models.FileField()

class UserTable (models.Model):
    LOGINID = models.ForeignKey(LoginTable, on_delete=models.CASCADE)
    Name = models.CharField(max_length=30)
    PLACE = models.CharField(max_length=25)
    POST = models.CharField(max_length=20)
    PIN = models.IntegerField()
    PHONE = models.BigIntegerField()
    EMAIL = models.CharField(max_length=30)
    Gender = models.CharField(max_length=10)
    photo = models.FileField()

class RatingTable (models.Model):
    Rating = models.CharField(max_length=100)
    DoctorID = models.ForeignKey(DoctorTable, on_delete=models.CASCADE)
    UserID = models.ForeignKey(UserTable, on_delete=models.CASCADE)
    Date = models.DateField()

class ComplaintsTable (models.Model):
    UserID = models.ForeignKey(UserTable, on_delete=models.CASCADE)
    COMPLAINT = models.CharField(max_length=100)
    DATE = models.DateField()
    REPLY = models.CharField(max_length=100)

class ScheduleTable (models.Model):
    DoctorID=models.ForeignKey(DoctorTable, on_delete=models.CASCADE)
    FromTime=models.TimeField()
    ToTime=models.TimeField()
    Date = models.DateField()
    Status = models.CharField(max_length=100)

class BookingTable(models.Model):
    ScheduleId = models.ForeignKey(ScheduleTable, on_delete=models.CASCADE)
    UserID = models.ForeignKey(UserTable, on_delete=models.CASCADE)
    Date = models.DateField()
    Status = models.CharField(max_length=100)

class PrescriptionTable(models.Model):
    BookId = models.ForeignKey(BookingTable, on_delete=models.CASCADE)
    Prescription = models.CharField(max_length=100)
    File = models.FileField()
    Report = models.CharField(max_length=100)


class DiseaseTable(models.Model):
    disease = models.CharField(max_length=500)
    treatment = models.CharField(max_length=500)
    preventive_measure = models.CharField(max_length=500)
    did = models.ForeignKey(DepartmentTable,on_delete=models.CASCADE)


class SymptomsTable(models.Model):
    disease_id = models.ForeignKey(DiseaseTable,on_delete=models.CASCADE)
    symptom = models.CharField(max_length=500)

