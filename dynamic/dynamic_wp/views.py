from django.shortcuts import render

# Create your views here.
def home(request):
   return render(request,"home.html")

def welcome(request):
    text = request.GET['text']
    return render(request,"welcome.html",{'text':text})