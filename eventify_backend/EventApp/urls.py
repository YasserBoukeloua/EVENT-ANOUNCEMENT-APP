from django.contrib import admin
from django.urls import path , include
from . import views 


urlpatterns =[

    # API Routes
    path('', views.getRoutes),


    
    # Event URLs
    path('events/', views.getEvents),
    path('events/create/', views.createEvent),
    path('events/<str:pk>/', views.getEvent),
    path('events/<str:pk>/update/', views.updateEvent),
    path('events/<str:pk>/delete/', views.deleteEvent),
    
    # User URLs
    path('users/', views.getUsers),
    path('users/create/', views.createUser),
    path('users/<str:pk>/', views.getUser),
    path('users/<str:pk>/update/', views.updateUser),
    path('users/<str:pk>/delete/', views.deleteUser),
    
    # Post URLs
    path('posts/', views.getPosts),
    path('posts/create/', views.createPost),
    path('posts/<str:pk>/', views.getPost),
    path('posts/<str:pk>/update/', views.updatePost),
    path('posts/<str:pk>/delete/', views.deletePost),
    path('posts/<str:pk>/like/', views.likePost),
    
    # Comment URLs
    path('comments/', views.getComments),
    path('comments/create/', views.createComment),
    path('comments/<str:pk>/', views.getComment),
    path('comments/<str:pk>/update/', views.updateComment),
    path('comments/<str:pk>/delete/', views.deleteComment),
    
    # Event Favorite URLs
    path('favorites/', views.getFavorites),
    path('favorites/create/', views.createFavorite),
    path('favorites/<str:pk>/', views.getFavorite),
    path('favorites/<str:pk>/delete/', views.deleteFavorite),
    
    # Photo URLs
    path('photos/', views.getPhotos),
    path('photos/create/', views.createPhoto),
    path('photos/<str:pk>/', views.getPhoto),
    path('photos/<str:pk>/delete/', views.deletePhoto),
]
