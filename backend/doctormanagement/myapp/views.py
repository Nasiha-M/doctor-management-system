import datetime
import json
import re
from django.contrib.auth import logout
from django.core.files.storage import FileSystemStorage
from django.db.models import Q
from django.http import HttpResponse, JsonResponse
from django.shortcuts import render, redirect
from myapp.models import *



def home(request):
    return render(request, 'loginindex.html')

# ------------------------------ ADMIN ------------------------------


def login(request):
    username = request.POST.get('username')
    password = request.POST.get('password')

    login_fetch = LoginTable.objects.filter(username=username,password=password).exists()
    if login_fetch:
        login_details = LoginTable.objects.get(username=username,password=password)
        request.session['lid'] = login_details.id
        if login_details.type == 'admin':
            return HttpResponse('''<script>alert('Admin Login Success'); window.location='admin_home';</script>''')
        elif login_details.type == 'hospital':
            return HttpResponse('''<script>alert('Hospital Login Success'); window.location='hospital_home';</script>''')
        elif login_details.type == 'doctor':
            return HttpResponse('''<script>alert('Doctor Login Success'); window.location='doctor_home';</script>''')
        else:
            return HttpResponse('''<script>alert('INVALID'); window.location='/';</script>''')
    else:
        return HttpResponse('''<script>alert('INVALID'); window.location='/';</script>''')

def admin_home(request):
    return render(request, 'admin/indexadmin.html')

def admin_logout(request):
    logout(request)
    return HttpResponse('''<script>alert('Admin Logout Success');window.location='/';  // Change to your login URL </script>''')

def approve_hospital(request):
    hospital_details = HospitalTable.objects.all()
    return render(request, 'admin/APPROVE HOSPITAL.html', {'hospital_details': hospital_details})

def accept_hospital(request, id):
    accept = LoginTable.objects.get(id=id)
    accept.type = 'hospital'
    accept.save()
    return HttpResponse('''<script>alert('Hospital Accepted Succesfully'); window.location='/approve_hospital';</script>''')

def reject(request, id):
    obj = LoginTable.objects.get(id=id)
    obj.delete()
    return HttpResponse('''<script>alert('Hospital Rejected Successfully'); window.location='/approve_hospital';</script>''')

def block_and_unblock(request):
    obj = HospitalTable.objects.filter(~Q(LOGINID__type='rejected'))
    return render(request, 'admin/BLOCK&UNBLOCK.html', {'values': obj})

def block(request, id):
    obj = LoginTable.objects.get(id=id)
    obj.type = "blocked"
    obj.save()
    return HttpResponse('''<script>alert('Hospital Blocked Successfully'); window.location='/block_and_unblock';</script>''')

def unblock(request, id):
    obj = LoginTable.objects.get(id=id)
    obj.type = 'hospital'
    obj.save()
    return HttpResponse('''<script>alert('Hospital Unblocked Successfully'); window.location='/block_and_unblock';</script>''')

def search_hospital(request):
    search_query = request.POST.get('textfield', '')
    if search_query:
        obj = HospitalTable.objects.filter(NAME__icontains=search_query)
    else:
        obj = HospitalTable.objects.all()
    return render(request,'admin/APPROVE HOSPITAL.html',{'hospital_details':obj , 'search_query':search_query})

def manage_department(request):
    obj = DepartmentTable.objects.all()
    return render(request, 'admin/MANAGE DEPARTMENT.html', {'values': obj})

def add_department(request):
    obj = DepartmentTable.objects.all()
    return render(request, 'admin/ADD DEPARTMENT.html', {'values': obj})

def add_department_post(request):
    Name = request.POST['textfield']
    Details = request.POST['textfield2']

    dept_obj = DepartmentTable()
    dept_obj.Name = Name
    dept_obj.Details = Details
    dept_obj.save()
    return HttpResponse('''<script>alert('Department Added Successfully'); window.location='/manage_department';</script>''')

def delete_department(request,id):
    obj = DepartmentTable.objects.get(id=id)
    obj.delete()
    return HttpResponse('''<script>alert('Department Deleted Successfully'); window.location='/manage_department';</script>''')

def rating(request, doctor_id):
    ratings = RatingTable.objects.filter(DoctorID_id=doctor_id)
    return render(request, 'admin/RATING.html', {'values': ratings})

def view_complaint(request):
    obj = ComplaintsTable.objects.all()
    return render(request, 'admin/VIEW COMPLAINTS.html', {'values': obj})


def search_date(request):
    search_query = request.POST.get('textfield', '')
    if search_query:
        try:
            obj = ComplaintsTable.objects.filter(DATE=search_query)
        except ValueError:
            obj = []
    else:
        obj = ComplaintsTable.objects.all()
    return render(request, 'admin/VIEW COMPLAINTS.html', {'values': obj})


def send_reply(request,id):
    request.session['cid']=id
    complaint = ComplaintsTable.objects.get(id=id)
    return render(request, 'admin/SEND RPLY.html')

def sent_reply(request):
    REPLY=request.POST['textfield']
    cid=request.session['cid']
    if cid:
        comp_obj = ComplaintsTable.objects.get(id=cid)
        comp_obj.REPLY = REPLY
        comp_obj.LOGINID = 'replied'
        comp_obj.save()
        del request.session['cid']
        return HttpResponse('''<script>alert('Complaint Replied Successfully'); window.location='/view_complaint';</script>''')
    return redirect('view_complaint')

def view_hospital_doctor(request):
    obj = HospitalTable.objects.all()
    return render(request, 'admin/VIEW HOSPITAL DOCTOR.html', {'values': obj})

def search_place(request):
    search_query = request.POST.get('textfield', '')
    if search_query:
        obj = HospitalTable.objects.filter(PLACE__icontains=search_query)
        no_matches = obj.count() == 0
    else:
        obj = HospitalTable.objects.none()
        no_matches = False
    return render(request, 'admin/VIEW HOSPITAL DOCTOR.html', {'values': obj,'search_query': search_query,'no_matches': no_matches})

def view_doctor(request, hospital_id):
    obj = DoctorTable.objects.filter(HospitalID=hospital_id)
    return render(request, 'admin/VIEW DOCTOR.html', {'values': obj})

def search_department(request):
    search_query = request.GET.get('textfield', '')
    if search_query:
        obj = DoctorTable.objects.filter(DepartmentID__Name__icontains=search_query)
    else:
        obj = DoctorTable.objects.all()
    return render(request, 'admin/VIEW DOCTOR.html', {'values': obj, 'search_query': search_query})


def view_user(request):
    obj = UserTable.objects.all()
    return render(request, 'admin/VIEW USER.html', {'values': obj})

def search_user(request):
    search_query = request.POST.get('textfield','')
    if search_query:
        obj = UserTable.objects.filter(Name__icontains=search_query)
    else:
        obj = UserTable.objects.none()
    return  render(request, 'admin/VIEW USER.html', {'values': obj, 'search_query':search_query})


# ------------------------------ DOCTOR ------------------------------

def doctor_home(request):
    if 'lid' in request.session:  # Check if the user is logged in
        doctor = DoctorTable.objects.filter(LOGINID=request.session['lid']).first()  # Fetch doctor details

        if doctor:
            return render(request, 'doctor/indexdoctor.html', {'doctor': doctor})

    return HttpResponse('''<script>alert('Unauthorized Access'); window.location='/';</script>''')

# def doctor_home(request):
#     return render(request,'doctor/indexdoctor.html')

def doctor_logout(request):
    logout(request)
    return HttpResponse('''<script>alert('Doctor Logout Success');window.location='/';  // Change to your login URL </script>''')

def prescription_interface(request, id):
    request.session['bid'] = id
    return render(request, 'doctor/PRESCRIPTION INTERFACE.html')

def prescription_interface_post(request):
        Prescription = request.POST['prescription']
        File = request.FILES['file']
        Report = request.POST['report']

        fs = FileSystemStorage()
        fp = fs.save(File.name, File)

        BookId = request.session['bid']
        BookId = BookingTable.objects.get(id=BookId)
        BookId.Status="Prescribed"
        BookId.save()

        prescription_details = PrescriptionTable()
        prescription_details.BookId = BookId
        prescription_details.Prescription = Prescription
        prescription_details.File = fp
        prescription_details.Report = Report
        prescription_details.save()

        return HttpResponse('''<script>alert('Prescription Added Successfully'); window.location='/view_booking';</script>''')


def view_prescription(request):
    doctor_id = request.session.get('lid')
    doctor = DoctorTable.objects.get(LOGINID=doctor_id)
    prescriptions = PrescriptionTable.objects.filter(BookId__ScheduleId__DoctorID=doctor)
    return render(request, 'doctor/VIEW PRESCRIPTION.html', {'values': prescriptions})

def view_booking(request):
    booking_id = DoctorTable.objects.get(LOGINID_id=request.session["lid"])
    obj = BookingTable.objects.filter(ScheduleId__DoctorID=booking_id.id)
    return render(request,'doctor/VIEW BOOKING.html', {'values': obj})

def view_schedule_status_update(request,id):
    request.session['cid'] = id
    Status = ScheduleTable.objects.get(id=id)
    return render(request,'doctor/VIEW SCHEDULE STATUS UPDATE.html',{'value':Status})

def schedule_status_reply(request):
    Status = request.POST['textfield']
    cid = request.session['cid']
    if cid:
        stat_obj = ScheduleTable.objects.get(id=cid)
        stat_obj.Status = Status
        stat_obj.LOGINID = 'replied'
        stat_obj.save()
        del request.session['cid']
    return HttpResponse('''<script>alert('Status Updated Successfully'); window.location='/view_scheduling';</script>''')

def view_scheduling(request):
    doctor_id = DoctorTable.objects.get(LOGINID_id=request.session["lid"])
    obj = ScheduleTable.objects.filter(DoctorID__scheduletable=doctor_id.id)
    return render(request, 'doctor/VIEW SCHEDULING.html', {'values': obj})

def search_doctor_schedule(request):
    search_query = request.POST.get('textfield', '')
    if search_query:
        try:
            obj = ScheduleTable.objects.filter(Date=search_query)
        except ValueError:
            obj = []
    else:
        obj = ScheduleTable.objects.all()
    return render(request, 'doctor/VIEW SCHEDULING.html', {'values': obj})

# ------------------------------ HOSPITAL ------------------------------

def hospital_registration(request):
    return render(request, 'hospital/HOSP REG.html')

def hospital_registration_post(request):
    NAME = request.POST['name']
    PLACE = request.POST['place']
    POST = request.POST['post']
    PIN = request.POST['pin']
    PHONE = request.POST['phone']
    EMAIL= request.POST['e-mail']
    image= request.FILES['image']
    latitude = request.POST['latitude']
    longitude = request.POST['longitude']
    username = request.POST['username']
    password = request.POST['password']

    PHONE = re.sub(r'\D', '', PHONE)
    PHONE = int(PHONE)

    latitude_value = float(latitude.split()[0])
    longitude_value = float(longitude.split()[0])

    login_details = LoginTable()
    login_details.username = username
    login_details.password = password
    login_details.type = "pending"
    login_details.save()

    fs = FileSystemStorage()
    fp = fs.save(image.name, image)

    hospital_details = HospitalTable()
    hospital_details.LOGINID = login_details
    hospital_details.NAME = NAME
    hospital_details.PLACE = PLACE
    hospital_details.POST = POST
    hospital_details.PIN = PIN
    hospital_details.PHONE = PHONE
    hospital_details.EMAIL = EMAIL
    hospital_details.latitude = latitude_value
    hospital_details.longitude = longitude_value
    hospital_details.photo = fp
    hospital_details.save()
    return HttpResponse('''<script>alert('Hospital Registered Successfully'); window.location='/';</script>''')

def hospital_home(request):
    if 'lid' in request.session:  # Ensure user is logged in
        hospital = HospitalTable.objects.filter(LOGINID=request.session['lid']).first()  # Fetch hospital details

        if hospital:
            return render(request, 'hospital/indexhospital.html', {'hospital': hospital})

    return HttpResponse('''<script>alert('Unauthorized Access'); window.location='/';</script>''')

# def hospital_home(request):
#     return render(request,'hospital/indexhospital.html')

def hospital_logout(request):
    logout(request)
    return HttpResponse('''<script>alert('Hospital Logout Success');window.location='/';  // Change to your login URL </script>''')

def manage_doctor(request):
    hospital = HospitalTable.objects.get(LOGINID=request.session["lid"])
    doctors = DoctorTable.objects.filter(HospitalID=hospital)
    return render(request, 'hospital/MANAGE DOCTOR.html', {'val': doctors})

# def manage_doctor(request):
#     obj = DoctorTable.objects.all()
#     return render(request,'hospital/MANAGE DOCTOR.html',{'val': obj})

def add_doctor(request):
    hospital = HospitalTable.objects.get(LOGINID__id=request.session['lid'])
    departments = DepartmentTable.objects.all()
    return render(request, 'hospital/ADD DOCTOR.html', {'value': departments, 'hospital': hospital})

def add_doctor_post(request):
    Name = request.POST['name']
    Department = request.POST['department']
    Age = request.POST['age']
    Experience = request.POST['experience']
    PHONE = request.POST['phone']
    EMAIL = request.POST['email']
    photo = request.FILES['image']
    username = request.POST['username']
    password = request.POST['password']
    hospital_id = request.POST['hospital_id']

    fs = FileSystemStorage()
    fp = fs.save(photo.name, photo)

    login_details = LoginTable(username=username, password=password, type="doctor")
    login_details.save()

    doctor_details = DoctorTable(
        Name=Name,
        Age=Age,
        Experience=Experience,
        PHONE=PHONE,
        EMAIL=EMAIL,
        photo=fp,
        LOGINID=login_details,
        DepartmentID=DepartmentTable.objects.get(id=Department),
        HospitalID=HospitalTable.objects.get(id=hospital_id),  # Use hospital ID
    )
    doctor_details.save()

    return HttpResponse('''<script>alert('Doctor Added Successfully'); window.location='/manage_doctor';</script>''')


def edit_doctor(request,id):
    request.session['did']=id
    a=DoctorTable.objects.get(id=id)
    b=DepartmentTable.objects.all()
    return render(request,'hospital/EDIT DOCTOR.html',{'values':a,'value':b})

def edit_doctor_post(request):
    Name = request.POST['name']
    DepartmentID = request.POST['department']
    Age = request.POST['age']
    Experience = request.POST['experience']
    PHONE = request.POST['phone']
    EMAIL = request.POST['email']
    NAME = request.POST['hospitalname']

    doctor_details = DoctorTable.objects.get(id=request.session['did'])
    doctor_details.Name = Name

    if DepartmentID:
        doctor_details.DepartmentID = DepartmentTable.objects.get(id=DepartmentID)
    else:
        return HttpResponse('Please select a valid department.')

    doctor_details.Age = Age
    doctor_details.Experience = Experience
    doctor_details.PHONE = PHONE
    doctor_details.EMAIL = EMAIL
    doctor_details.NAME = NAME
    doctor_details.LOGINID_id = request.session['lid']
    doctor_details.HospitalID = HospitalTable.objects.get(LOGINID__id=request.session['lid'])
    doctor_details.save()

    return HttpResponse('''<script>alert('Doctor Edited Successfully'); window.location='/manage_doctor';</script>''')

def delete_doctor(request,id):
    obj = DoctorTable.objects.get(id=id)
    obj.delete()
    return HttpResponse('''<script>alert('Doctor Deleted Successfully'); window.location='/manage_doctor';</script>''')

def search_doctor(request):
    search_query = request.POST.get('textfield','')
    if search_query:
        obj = DoctorTable.objects.filter(Name__icontains=search_query)
    else:
        obj = DoctorTable.objects.all()
    return render(request, 'hospital/MANAGE DOCTOR.html', {'val':obj, 'search_query':search_query})


def manage_schedule(request):
    hospital = HospitalTable.objects.get(LOGINID=request.session['lid'])
    schedules = ScheduleTable.objects.filter(DoctorID__HospitalID=hospital)
    return render(request, 'hospital/MANAGE SCHEDULE.html', {'values': schedules})


# def manage_schedule(request):
#     obj = ScheduleTable.objects.all()
#     return render(request,'hospital/MANAGE SCHEDULE.html',{'values': obj})

def add_schedule(request):
    doctors = DoctorTable.objects.all()
    return render(request, 'hospital/ADD NEW INTERFACE.html', {'doctors': doctors})

def add_schedule_post(request):
    if request.method == "POST":
        DoctorID = request.POST.get('DoctorID')
        FromTime = request.POST.get('FromTime')
        ToTime = request.POST.get('ToTime')
        Date = request.POST.get('Date')

        schedule_details = ScheduleTable()
        schedule_details.DoctorID = DoctorTable.objects.get(id=DoctorID)
        schedule_details.FromTime = FromTime
        schedule_details.ToTime = ToTime
        schedule_details.Date = Date
        schedule_details.Status = 'pending'
        schedule_details.save()

        return HttpResponse('''<script>alert('Schedule Added Successfully'); window.location='/manage_schedule';</script>''')
    else:
        return HttpResponse('Invalid request method.')

def edit_schedule(request, id):
    schedule = ScheduleTable.objects.get(id=id)
    doctors = DoctorTable.objects.all()

    if request.method == "POST":
        DoctorID = request.POST.get('DoctorID')
        FromTime = request.POST.get('FromTime')
        ToTime = request.POST.get('ToTime')
        Date = request.POST.get('Date')

        if DoctorID and FromTime and ToTime and Date:
            schedule.DoctorID = DoctorTable.objects.get(id=DoctorID)
            schedule.FromTime = FromTime
            schedule.ToTime = ToTime
            schedule.Date = Date
            schedule.save()

            return HttpResponse('''<script>alert('Schedule Updated Successfully'); window.location='/manage_schedule';</script>''')
        else:
            return HttpResponse('Please fill out all fields.')
    else:
        return render(request, 'hospital/EDIT SCHEDULE.html', {'schedule': schedule, 'doctors': doctors})


def delete_schedule(request, id):
        obj = ScheduleTable.objects.get(id=id)
        obj.delete()
        return HttpResponse('''<script>alert('Schedule Deleted Successfully'); window.location='/manage_schedule';</script>''')


def view_hospital_booking(request):
    if 'lid' in request.session:
        try:
            hospital = HospitalTable.objects.get(LOGINID_id=request.session['lid'])
            doctors = DoctorTable.objects.filter(HospitalID=hospital)
            doctor_schedules = ScheduleTable.objects.filter(DoctorID__in=doctors)
            bookings = BookingTable.objects.filter(ScheduleId__in=doctor_schedules)
            return render(request, 'hospital/VIEW BOOKING.html', {'values': bookings})
        except HospitalTable.DoesNotExist:
            print("No hospital found for this user")
            return render(request, 'hospital/VIEW BOOKING.html', {'values': []})
    print("Session does not contain 'lid'")
    return render(request, 'hospital/VIEW BOOKING.html', {'values': []})
#
# def view_hospital_booking(request):
#     obj = BookingTable.objects.all()
#     return render(request,'hospital/VIEW BOOKING.html',{'values':obj})

def search_booking_date(request):
    search_query = request.POST.get('textfield', '')
    if search_query:
        try:
            obj = BookingTable.objects.filter(Date=search_query)
        except ValueError:
            obj = []
    else:
        obj = BookingTable.objects.all()
    return render(request, 'hospital/VIEW BOOKING.html', {'values': obj})

def accept_booking(request, id):
    obj = BookingTable.objects.get(id=id)
    obj.Status = 'Booking Confirmed'
    obj.save()
    return HttpResponse('''<script>alert('Booking Accepted Successfully'); window.location='/view_hospital_booking';</script>''')


def reject_booking(request, id):
    obj = BookingTable.objects.get(id=id)
    obj.delete()
    return HttpResponse('''<script>alert('Booking Rejected Successfully'); window.location='/view_hospital_booking';</script>''')


# ------------------------------ FLUTTER ------------------------------


def logincode(request):
    print(request.POST)
    un = request.POST['username']
    pwd = request.POST['password']
    print(un, pwd)
    try:
        ob = LoginTable.objects.get(username=un, password=pwd)

        if ob is None:
            data = {"task": "invalid"}
        else:
            print("in user function")
            data = {
                "task": "valid",
                "lid": ob.id,
                "type":ob.type
            }
        r = json.dumps(data)
        print(r)
        return HttpResponse(r)
    except:
        data = {"task": "invalid"}
        r = json.dumps(data)
        print(r)
        return HttpResponse(r)

def view_hospital(request):
    hospitals = HospitalTable.objects.filter(LOGINID__type="hospital")
    mdata = []

    for hospital in hospitals :
        data = {
            "hospital_name" : hospital.NAME,
            "place" : hospital.PLACE,
            "pin" : hospital.PIN,
            "phone" : hospital.PHONE,
            "email" : hospital.EMAIL,
            "id" : hospital.id,
            'image_url' : hospital.photo.url,
        }
        mdata.append(data)

    return JsonResponse({"status" : "ok", "data" : mdata})


def usersearch_hospital(request):
    hospital_name = request.POST.get("hospital_name")
    obj = HospitalTable.objects.filter(NAME__icontains=hospital_name,LOGINID__type="hospital")
    mdata = []

    for hospital in obj:
        data = {
            "id" : hospital.id,
            "hospital_name" : hospital.NAME,
            "place" : hospital.PLACE,
            "pin" : hospital.PIN,
            "post" : hospital.POST,
            "phone" : hospital.PHONE
        }
        mdata.append(data)

        return JsonResponse({"status" : "ok" , "data" : mdata})


def userview_doctor(request):
    hosid=request.POST["hosid"]
    doctors = DoctorTable.objects.filter(HospitalID=hosid)
    mdata =[]

    for doctor in doctors:
        data = {
            "name" : doctor.Name,
            "age" : str(doctor.Age),
            "department" : doctor.DepartmentID.Name,
            "experience" : doctor.Experience,
            "phone" : str(doctor.PHONE),
            "email" : doctor.EMAIL,
            'image_url' : doctor.photo.url,
            "id" : doctor.id,
        }
        mdata.append(data)
    return JsonResponse({"status" : "ok" , "data" : mdata})


def view_schedule(request):
    doctor_id = request.POST['doctor_id']
    schedule =ScheduleTable.objects.filter(DoctorID__id=doctor_id,Status="Available")
    mdata =[]

    for i in schedule:
        data = {

            'fid':i.FromTime,
            'tid':i.ToTime,
            'date':i.Date,
            'id':i.id,
        }
        mdata.append(data)
    return JsonResponse({"status": "ok" , "data":mdata})


def sendcomplaint(request):
    comp = request.POST['complaint']
    lid = request.POST['lid']
    print(lid)
    lob = ComplaintsTable()
    lob.UserID = UserTable.objects.get(LOGINID__id=lid)
    lob.COMPLAINT = comp
    lob.DATE = datetime.datetime.now().today()
    lob.REPLY='pending'
    lob.save()
    return JsonResponse({'task': 'ok'})


def viewcomplaint(request):
    lid=request.POST['lid']
    ob=ComplaintsTable.objects.filter(UserID__LOGINID_id=lid)
    mdata=[]
    for i in ob:
        data={'complaint':i.COMPLAINT,
              'date':str(i.DATE),
              'id':i.id,
              'reply':i.REPLY
              }
        mdata.append(data)
    return JsonResponse({"status":"ok","data":mdata})


def send_rating(request):
    lid=request.POST['lid']
    did=request.POST['did']
    Rating=request.POST['rating']
    a=RatingTable()
    a.Rating=Rating
    a.Date=datetime.datetime.now().today()
    a.DoctorID=DoctorTable.objects.get(id=did)
    a.UserID=UserTable.objects.get(LOGINID_id=lid)
    a.save()
    return JsonResponse({"task":"ok"})


def user_booking(request):
    lid = request.POST['lid']
    sid = request.POST['sid']
    date = str(datetime.datetime.now().date().today())
    cc = BookingTable.objects.filter(ScheduleId_id=sid,UserID__LOGINID_id=lid,Date=date)
    if cc.exists():
        return JsonResponse({'status': "Not Ok"})

    a = BookingTable()
    a.ScheduleId = ScheduleTable.objects.get(id=sid)
    a.UserID = UserTable.objects.get(LOGINID_id=lid)
    a.Status = 'pending'
    a.Date = datetime.datetime.now().date().today()
    a.save()
    return JsonResponse({'status': 'ok'})


def view_userbooking(request):
    lid = request.POST['lid']
    ob = BookingTable.objects.filter(UserID__LOGINID_id=lid)
    mdata = []
    for i in ob:
        data = {
            'doctor': i.ScheduleId.DoctorID.Name,
            'fid' : i.ScheduleId.FromTime,
            'tid' : i.ScheduleId.ToTime,
            'date': str(i.Date),
            'id': i.id,
        }
        mdata.append(data)
    return JsonResponse({"status": "ok", "data": mdata})

def view_userprescription(request):
    # lid = request.POST['lid']
    prescripton =PrescriptionTable.objects.all()
    mdata =[]

    for i in prescripton:
        data = {

            'doctor':i.BookId.ScheduleId.DoctorID.Name,
            'prescription':i.Prescription,
            'report': i.Report,
            'file': i.File.url,
            'date':i.BookId.Date,
            'id':i.id,
        }
        mdata.append(data)
    return JsonResponse({"status": "ok" , "data":mdata})

# def cancel_booking(request):
#     booking_id = request.POST.get('bid')
#
#     if not booking_id:
#         return JsonResponse({
#             'status': 'error',
#             'message': 'Booking ID not Provided'
#         }, status=400)
#
#     try:
#         booking = BookingTable.objects.get(id=booking_id)
#         booking.Status = 'cancel'
#         booking.save()
#
#         return JsonResponse({
#             'status': 'ok'
#         })
#     except BookingTable.DoesNotExist:
#         return JsonResponse({
#             'status': 'error',
#             'message': 'Booking ID not Found'
#         }, status=404)




def cancel_booking(request):
    did=request.POST['did']
    ob=BookingTable.objects.get(id=did)
    ob.delete()
    return JsonResponse({
                'status': 'ok'
            })

def book_schedule(request):
    if request.method == 'POST' :
        user_id = request.POST.get('UserID')
        schedule_id = request.POST.get('ScheduleId')

        if not all(user_id,schedule_id):
            return JsonResponse({
                'task' : 'error',
                'message' : 'Missing required fields'
            })

        booking = BookingTable(UserID=user_id, ScheduleId= schedule_id)
        booking.save()
        return JsonResponse({'task' : 'ok'})

    return JsonResponse({'task' : 'error' , 'message' : 'Invalid Request method'})


def user_registration(request):
    name = request.POST['name']
    place = request.POST['place']
    post = request.POST['post']
    pin = request.POST['pin']
    phone = request.POST['phone']
    email = request.POST['email']
    photo = request.FILES['image']
    username = request.POST['username']
    password = request.POST['password']

    ob=LoginTable()
    ob.username=username
    ob.password=password
    ob.type='user'
    ob.save()

    ob1=UserTable()
    ob1.LOGINID=ob
    ob1.Name=name
    ob1.PLACE=place
    ob1.POST=post
    ob1.PIN=pin
    ob1.PHONE=phone
    ob1.EMAIL=email
    ob1.photo=photo
    ob1.save()

    return JsonResponse({"status":"ok"})

def user_view_profile(request):
    lid = request.POST['lid']
    ob =UserTable.objects.get(LOGINID=lid)
    return JsonResponse({
        "status" : "ok" ,
        "name" :ob.Name,
        "email" : ob.EMAIL,
        "photo" : str(ob.photo.url)
    })

#-------------------------------------------------------------------------


import numpy as np


def cosine_similarity(list1, list2):
    # Convert lists to numpy arrays
    vector1 = np.array(list1)
    vector2 = np.array(list2)

    # Calculate the dot product
    dot_product = np.dot(vector1, vector2)

    # Calculate the magnitudes of the vectors
    magnitude1 = np.linalg.norm(vector1)
    magnitude2 = np.linalg.norm(vector2)

    # Calculate cosine similarity
    similarity = dot_product / (magnitude1 * magnitude2)

    return similarity
# def predict_diet(request):
#     if request.method == 'POST':
#         data = json.loads(request.body)
#
#         # Extract input data
#         gender = data.get('Gender')
#         obesity = data.get('Obicity')
#         alcohol_abuse = data.get('Alcoholabuse')
#         drug_use = data.get('Druguse')
#         smoking = data.get('Smoking')
#         headaches = data.get('Headaches')
#         asthma = data.get('Asthma')
#         cancer = data.get('Cancer')
#         stroke = data.get('Stroke')
#         kidney = data.get('Kidney')
#         liver = data.get('Liver')
#         depression = data.get('Depression')
#         allergies = data.get('Allergies')
#         arthritis = data.get('Arthritis')
#         pregnancy = data.get('Pregnancy')
#         bmi = data.get('BMI')
#         blood_pressure = data.get('BloodPressure')
#
#         l_gender =[]
#         l_obesity = []
#         l_alcohol_abuse = []
#         l_drug_use = []
#         l_smoking = []
#         l_headaches = []
#         l_asthma = []
#         l_cancer = []
#         l_stroke = []
#         l_kidney = []
#         l_liver = []
#         l_depression = []
#         l_allergies = []
#         l_arthritis = []
#         l_pregnancy = []
#
#         l_blood_pressure = []
#
#
#
#
#
#
#
#
#
#         # Arthritis = models.CharField(max_length=100)
#         # Pregnancy = models.CharField(max_length=100)
#         # bmi = models.FloatField(max_length=100)
#
#         ob=Diet_chart.objects.all()
#         res=[]
#         dataset=[]
#         for i in ob:
#             r=[]
#             if i.Gender not in l_gender:
#                 l_gender.append(i.Gender)
#
#
#
#             if i.Obicity not in l_obesity:
#                 l_obesity.append(i.Obicity)
#
#             if i.Bloodpressure not in l_blood_pressure:
#                 l_blood_pressure.append(i.Bloodpressure)
#
#             if i.Alcoholabuse not in l_alcohol_abuse:
#                 l_alcohol_abuse.append(i.Alcoholabuse)
#
#             if i.Druguse not in l_drug_use:
#                 l_drug_use.append(i.Druguse)
#
#
#             if i.Asthma not in l_asthma:
#                 l_asthma.append(i.Asthma)
#
#             if i.Headaches not in l_headaches:
#                 l_headaches.append(i.Headaches)
#
#
#             if i.Liver not in l_liver:
#                 l_liver.append(i.Liver)
#
#             if i.Stroke not in l_stroke:
#                 l_stroke.append(i.Stroke)
#
#             if i.Kidney not in l_kidney:
#                 l_kidney.append(i.Kidney)
#             if i.Depression not in l_depression:
#                 l_depression.append(i.Depression)
#
#             if i.Allergies not in l_allergies:
#                 l_allergies.append(i.Allergies)
#
#
#             if i.Pregnancy not in l_pregnancy:
#                 l_pregnancy.append(i.Pregnancy)
#
#
#             if i.Smoking not in l_smoking:
#                 l_smoking.append(i.Smoking)
#
#             if i.Cancer not in l_cancer:
#                 l_cancer.append(i.Cancer)
#
#
#             r.append(l_gender.index(i.Gender))
#             r.append(l_obesity.index(i.Obicity))
#             r.append(l_blood_pressure.index(i.Bloodpressure))
#             r.append(l_alcohol_abuse.index(i.Alcoholabuse))
#             r.append(l_drug_use.index(i.Druguse))
#             r.append(l_asthma.index(i.Asthma))
#             r.append(l_headaches.index(i.Headaches))
#             r.append(l_liver.index(i.Liver))
#             r.append(l_stroke.index(i.Stroke))
#             r.append(l_kidney.index(i.Kidney))
#             r.append(l_depression.index(i.Depression))
#             r.append(l_allergies.index(i.Allergies))
#             r.append(l_pregnancy.index(i.Pregnancy))
#             r.append(l_smoking.index(i.Smoking))
#             r.append(l_cancer.index(i.Cancer))
#             r.append(float(i.bmi))
#
#             dataset.append(r)
#             res.append(i.id)
#         feat=[]
#         print(l_gender)
#         try:
#             feat.append(l_gender.index(gender))
#         except:
#             feat.append(-1)
#         try:
#             feat.append(l_obesity.index(obesity))
#         except:
#             feat.append(-1)
#         try:
#             feat.append(l_blood_pressure.index(blood_pressure))
#         except:
#             feat.append(-1)
#         try:
#             feat.append(l_alcohol_abuse.index(alcohol_abuse))
#         except:
#             feat.append(-1)
#         try:
#             feat.append(l_drug_use.index(drug_use))
#         except:
#             feat.append(-1)
#         try:
#             feat.append(l_asthma.index(asthma))
#         except:
#             feat.append(-1)
#         try:
#             feat.append(l_headaches.index(headaches))
#         except:
#             feat.append(-1)
#         try:
#             feat.append(l_liver.index(liver))
#         except:
#             feat.append(-1)
#         try:
#             feat.append(l_stroke.index(stroke))
#         except:
#             feat.append(-1)
#         try:
#             feat.append(l_kidney.index(kidney))
#         except:
#             feat.append(-1)
#         try:
#             feat.append(l_depression.index(depression))
#         except:
#             feat.append(-1)
#         try:
#             feat.append(l_allergies.index(allergies))
#         except:
#             feat.append(-1)
#         try:
#             feat.append(l_pregnancy.index(pregnancy))
#         except:
#             feat.append(-1)
#         try:
#             feat.append(l_smoking.index(smoking))
#         except:
#             feat.append(-1)
#         try:
#             feat.append(l_cancer.index(cancer))
#         except:
#             feat.append(-1)
#         try:
#             feat.append(float(bmi))
#         except:
#             feat.append(-1)
#         reslist=[]
#         print(feat,"feat")
#         for i in range(0,len(dataset)):
#             print(dataset[i])
#             dis=cosine_similarity(feat,dataset[i])
#             reslist.append({"id":res[i],"dis":dis})
#         print(reslist)
#
#         # Example logic to generate diet plan (use your algorithm or model here)
#         diet_plan = "This is a predicted diet plan based on your input conditions."
#         sorted_data = sorted(reslist, key=lambda x: x['dis'], reverse=True)
#         ids=[]
#         print(sorted_data)
#         for i in sorted_data:
#             ids.append(i['id'])
#             if len(ids)>3:
#                 break
#         mdata = []
#         diet_charts = Diet_chart.objects.filter(id__in=ids)
#         for i in diet_charts:
#             data = {
#                 'name': i.Name,
#                 'date': i.Date,
#                 'time': i.Time,
#                 'dietplan': i.Dietplan,
#                 'gender': i.Gender,
#                 'obicity': i.Obicity,
#                 'bloodpressure': i.Bloodpressure,
#                 'diabetes': i.Diabetes,
#                 'cholestrol': i.Cholestrol,
#                 'alcoholabuse': i.Alcoholabuse,
#                 'druguse': i.Druguse,
#                 'smoking': i.Smoking,
#                 'headaches': i.Headaches,
#                 'asthma': i.Asthma,
#                 'heartproblem': i.Heartproblem,
#                 'cancer': i.Cancer,
#                 'stroke': i.Stroke,
#                 'kidney': i.Kidney,
#                 'liver': i.Liver,
#                 'depression': i.Depression,
#                 'allergies': i.Allergies,
#                 'arthritis': i.Arthritis,
#                 'pregnancy': i.Pregnancy,
#                 'bmi': i.bmi
#             }
#             mdata.append(data)
#         print(mdata)
#
#         return JsonResponse({'dietPlans': mdata})

import pymysql
from .myknn import prep


def AV_symptoms(request):



    ob = SymptomsTable.objects.all()

    data = []
    for i in ob:
        row = {'symptom': i.symptom }
        if row not in data:
            data.append(row)
    print(data)
    r = json.dumps(data)
    return HttpResponse(r)
def AV_symptoms1(request):
    print(request.POST,"jhhhhhhhhhhhhj")
    print(request.POST,"jhhhhhhhhhhhhj")
    print(request.POST,"jhhhhhhhhhhhhj")
    print(request.POST,"jhhhhhhhhhhhhj")
    sym = request.POST['sym']
    syms = sym.split("#")
    print("---", syms)
    symrow = []
    for i in syms:

        if i != "":
            symrow.append(i)


    print(symrow)
    symrow = ",".join(symrow)
    print(symrow)
    symrow = "'" + symrow + "'"
    symrow = symrow.replace(",", "','")

    con = pymysql.connect(
    host='localhost',
    user='root',
    password=os.environ.get('DB_PASSWORD', ''),
    port=3306,
    db='doctormanagement'
)
    cmd = con.cursor()
    qry = "SELECT DISTINCT `disease_id_id` FROM `myapp_symptomstable` WHERE `symptom` IN(" + symrow + ")"
    cmd.execute(qry)
    resss = cmd.fetchall()

    distdi = []
    for i in resss:
        print(i)
        distdi.append(str(i[0]))

    distdi = ','.join(distdi)

    try:
        cmd.execute("SELECT DISTINCT `symptom` FROM `myapp_symptomstable` WHERE `disease_id_id` IN(" + distdi + ") ORDER BY `symptom`")
    except:
        return JsonResponse({"task": "failed"})
    s = cmd.fetchall()
    print(s)
    dsym = []
    for i in s:
        dsym.append(i[0])
    row = []
    for w in dsym:
        if w in syms:
            row.append(1)
        else:
            row.append(0)
    print("========",row)
    print("========",distdi)
    ress = prep([row], distdi)
    qry = "SELECT `disease`,`treatment`,`preventive_measure`,`did_id` FROM `myapp_diseasetable` WHERE id=" + str(ress)
    cmd.execute(qry)
    res = cmd.fetchone()
    print(res[0], "aaaaaaaaaaaaaa")
    return JsonResponse({"task": res[0], "t": res[1], "pm": res[2], "did": str(res[3])})