from django.contrib import admin
from django.urls import path , include
from django.conf.urls.static  import static
from django.conf import settings

urlpatterns = [
    path("BIGBOSS/", admin.site.urls),
    path( '' , include('EventApp.urls')),
    
]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
print(f"Media files will be served from: {settings.MEDIA_ROOT}")
print(f"Media URL pattern: {settings.MEDIA_URL}")
