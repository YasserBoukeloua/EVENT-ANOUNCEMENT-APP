from rest_framework import serializers
from .models import Event, User, Post, Comment, Photo, EventFavorite, Repost


class UserSerializer(serializers.ModelSerializer):
    photo = serializers.SerializerMethodField()
    
    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'name', 'lastname', 'photo')
    
    def get_photo(self, obj):
        if obj.photo:
            # Return full URL for Cloudinary or local storage
            if hasattr(obj.photo, 'url'):
                url = obj.photo.url
                # If it's a Cloudinary URL, it's already absolute
                if url.startswith('http'):
                    return url
                # For local storage, build absolute URI
                request = self.context.get('request')
                if request:
                    return request.build_absolute_uri(url)
                return url
        return None


class PhotoSerializer(serializers.ModelSerializer):
    image = serializers.SerializerMethodField()
    
    class Meta:
        model = Photo
        fields = ['id', 'content_type', 'image', 'uploaded_at', 'event', 'post']
    
    def get_image(self, obj):
        if obj.image:
            url = obj.image.url
            # If it's a Cloudinary URL, it's already absolute
            if url.startswith('http'):
                return url
            # For local storage, build absolute URI
            request = self.context.get('request')
            if request:
                return request.build_absolute_uri(url)
            return url
        return None

class CommentSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)

    class Meta:
        model = Comment
        fields = '__all__'


class PostSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    photos = PhotoSerializer(many=True, read_only=True)
    comments = CommentSerializer(many=True, read_only=True)

    class Meta:
        model = Post
        fields = '__all__'


class EventSerializer(serializers.ModelSerializer):
    creator = UserSerializer(read_only=True)
    photos = PhotoSerializer(many=True, read_only=True)
    posts = PostSerializer(many=True, read_only=True)

    class Meta:
        model = Event
        fields = '__all__'


class EventFavoriteSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    event = EventSerializer(read_only=True)

    class Meta:
        model = EventFavorite
        fields = '__all__'


class RepostSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    event = EventSerializer(read_only=True)

    class Meta:
        model = Repost
        fields = ['id', 'user', 'event', 'caption', 'created_at']


