from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.utils import timezone
from datetime import date 

# add id for the users and events and posts models  
class UserManager(BaseUserManager):
    """Custom user manager"""
    
    def create_user(self, email, username, password, name=None, lastname=None, date_of_birth=None):
        if not email:
            raise ValueError('Users must have an email address')
        if not username:
            raise ValueError('Users must have a username')
        if not password:
            raise ValueError('Users must have a password')

        email = self.normalize_email(email)
        
        user = self.model(
            email=email, 
            username=username,
            name=name or 'User',
            lastname=lastname or '',
            date_of_birth=date_of_birth
        )
        user.set_password(password)  
        user.save(using=self._db)
        return user
    
    def create_superuser(self, email, username, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_certified', True)

        
        return self.create_user(email, username, password, **extra_fields)


class User(AbstractBaseUser, PermissionsMixin):
    """Custom User model"""

    email = models.EmailField(unique=True, max_length=255)
    username = models.CharField(unique=True, max_length=150)
    name = models.CharField(max_length=255)
    lastname = models.CharField(max_length=255)
    date_of_birth = models.DateField(null=True, blank=True)
    is_certified = models.BooleanField(default=False)
    photo = models.ImageField(upload_to='user_photos/', null=True, blank=True)

    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    date_joined = models.DateTimeField(default=timezone.now)
    
    groups = models.ManyToManyField(
        'auth.Group',
        verbose_name='groups',
        blank=True,
        related_name='eventapp_user_set',
        related_query_name='eventapp_user',
    )
    user_permissions = models.ManyToManyField(
        'auth.Permission',
        verbose_name='user permissions',
        blank=True,
        related_name='eventapp_user_set',
        related_query_name='eventapp_user',
    )
    
    objects = UserManager()
    
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['email','username', 'password']
    
    class Meta:
        db_table = 'users'
        verbose_name = 'User'
        verbose_name_plural = 'Users'
    
    def __str__(self):
        return f"User(id={self.id}, email={self.email}, username={self.username}, name={self.name}, lastname={self.lastname})"
    
    def get_full_name(self):
        return f"{self.name} {self.lastname}"


class Event(models.Model):
    """Event model"""
    
    creator = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='created_events',
        db_column='creator_id'
    )
    title = models.CharField(max_length=255)
    description = models.TextField()
    date = models.DateField(default=timezone.now)
    location = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    
    class Meta:
        db_table = 'events'
        ordering = ['-date']
        indexes = [
            models.Index(fields=['date']),
            models.Index(fields=['creator']),
        ]
    
    def __str__(self):
        return self.title
    
    @property
    def is_upcoming(self):
        return self.date >= timezone.now().date()


class Post(models.Model):
    """Post model for event updates"""
    

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='posts',
        db_column='user_id'
    )
    event = models.ForeignKey(
        Event,
        on_delete=models.CASCADE,
        related_name='posts',
        null=True,
        blank=True
    )
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    num_likes = models.IntegerField(default=0)
    num_saves = models.IntegerField(default=0)
    
    
    class Meta:
        db_table = 'posts'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['-created_at']),
            models.Index(fields=['user']),
        ]
    
    def __str__(self):
        return f"Post by {self.user.username} at {self.created_at}"


class Comment(models.Model):
    """Comment model for posts"""
    
    post = models.ForeignKey(
        Post,
        on_delete=models.CASCADE,
        related_name='comments',
        db_column='post_id'
    )
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='comments',
        db_column='user_id'
    )
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'comments'
        ordering = ['created_at']
        indexes = [
            models.Index(fields=['post']),
            models.Index(fields=['created_at']),
        ]
    
    def __str__(self):
        return f"Comment by {self.user.username} on {self.post.id}"


class EventFavorite(models.Model):
    """Event favorites/bookmarks"""
    
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='favorite_events',
        db_column='user_id'
    )
    event = models.ForeignKey(
        Event,
        on_delete=models.CASCADE,
        related_name='favorited_by',
        db_column='event_id'
    )
    saved_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'event_favorites'
        unique_together = ['user', 'event']
        indexes = [
            models.Index(fields=['user', 'event']),
        ]
    
    def __str__(self):
        return f"{self.user.username} favorited {self.event.title}"


class Photo(models.Model):
    """Photo model for events and posts"""
    
    EVENT = 'event'
    POST = 'post'
    CONTENT_CHOICES = [
        (EVENT, 'Event'),
        (POST, 'Post'),
    ]
    
    content_type = models.CharField(max_length=10, choices=CONTENT_CHOICES)
    event = models.ForeignKey(
        Event,
        on_delete=models.CASCADE,
        related_name='photos',
        null=True,
        blank=True,
        db_column='event_id'
    )
    post = models.ForeignKey(
        Post,
        on_delete=models.CASCADE,
        related_name='photos',
        null=True,
        blank=True,
        db_column='post_id'
    )
    
    image = models.ImageField(upload_to='photos/', default='dall.png', blank=True)
    uploaded_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'photos'
        ordering = ['uploaded_at']
        indexes = [
            models.Index(fields=['content_type', 'event']),
            models.Index(fields=['content_type', 'post']),
        ]
        constraints = [
            models.CheckConstraint(
                condition=models.Q(event__isnull=False, post__isnull=True) | models.Q(event__isnull=True, post__isnull=False),
                name='photo_either_event_or_post'
            ),
        ]
    
    def __str__(self):
        if self.event:
            return f"Photo for Event {self.event.id}"
        return f"Photo for Post {self.post.id}"
    
    def save(self, *args, **kwargs):
        if self.event:
            count = Photo.objects.filter(event=self.event).count()
            if count >= 10 and not self.id:
                raise ValueError(f"Cannot add more than 10 photos to an event")
        elif self.post:
            count = Photo.objects.filter(post=self.post).count()
            if count >= 10 and not self.id:
                raise ValueError(f"Cannot add more than 10 photos to a post")
        super().save(*args, **kwargs)


class Repost(models.Model):
    """Repost model for sharing events"""
    
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='reposts',
        db_column='user_id'
    )
    event = models.ForeignKey(
        Event,
        on_delete=models.CASCADE,
        related_name='reposts',
        db_column='event_id'
    )
    caption = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'reposts'
        unique_together = ['user', 'event']
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['user']),
            models.Index(fields=['event']),
            models.Index(fields=['-created_at']),
        ]
    
    def __str__(self):
        return f"{self.user.username} reposted {self.event.title}"
