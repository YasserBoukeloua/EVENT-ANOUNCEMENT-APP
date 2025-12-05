# from django.shortcuts import render
# from .models import User


# def index(request):
#     users = User.objects.all()
#     context = {'users': users}
#     print(users)    
#     return render( request , 'events/index.html', context)

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .serializers import (
    EventSerializer, UserSerializer, PostSerializer,
    CommentSerializer, EventFavoriteSerializer, PhotoSerializer
)
from .models import Event, User, Post, Comment, EventFavorite, Photo
@api_view(['GET'])
def getRoutes(request):
    routes = [
        {
            'Endpoint': '/events/',
            'method': 'GET',
            'body': None,
            'description': 'Returns an array of events'
        },
        {
            'Endpoint': '/events/id',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single event object'
        },
        {
            'Endpoint': '/events/create/',
            'method': 'POST',
            'body': {'body': ""},
            'description': 'Creates new event with data sent in post request'
        },
        {
            'Endpoint': '/events/id/update/',
            'method': 'PUT',
            'body': {'body': ""},
            'description': 'Updates an existing event with data sent in post request'
        },
        {
            'Endpoint': '/events/id/delete/',
            'method': 'DELETE',
            'body': None,
            'description': 'Deletes and exiting event'
        },
    ]
    return Response(routes)

    #Events Views

@api_view(['GET'])
def getEvents(request):
    events = Event.objects.all().order_by('-created_at')
    # Pass request to serializer so it can build absolute URIs
    serializer = EventSerializer(events, many=True, context={'request': request})
    return Response(serializer.data)

@api_view(['GET'])
def getEvent(request, pk):
    try:
        event = Event.objects.get(id=pk)
        serializer = EventSerializer(event, context={'request': request})
        return Response(serializer.data)
    except Event.DoesNotExist:
        return Response({'error': 'Event not found'}, status=status.HTTP_404_NOT_FOUND)


@api_view(['POST'])
def createEvent(request):
    data = request.data
    try:
        event = Event.objects.create(
            creator=request.user,
            title=data['title'],
            description=data['description'],
            date=data['date'],
            location=data['location'],
            photo_url=data.get('photo_url', '')
        )
        serializer = EventSerializer(event, many=False)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    except KeyError as e:
        return Response({'error': f'Missing required field: {str(e)}'}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['PUT'])
def updateEvent(request, pk):
    try:
        event = Event.objects.get(id=pk)
    except Event.DoesNotExist:
        return Response({'error': 'Event not found'}, status=status.HTTP_404_NOT_FOUND)

    # Only the creator or staff can update
    if event.creator != request.user and not request.user.is_staff:
        return Response({'error': 'You can only update your own events'}, status=status.HTTP_403_FORBIDDEN)

    data = request.data.copy()
    serializer = EventSerializer(event, data=data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
@api_view(['DELETE'])
def deleteEvent(request, pk):
    try:
        event = Event.objects.get(id=pk)
        
        if event.creator != request.user:
            return Response({'error': 'You can only delete your own events'}, status=status.HTTP_403_FORBIDDEN)
        
        event.delete()
        return Response({'message': 'Event deleted successfully'}, status=status.HTTP_204_NO_CONTENT)
    except Event.DoesNotExist:
        return Response({'error': 'Event not found'}, status=status.HTTP_404_NOT_FOUND)




@api_view(['GET'])
def getUsers(request ):
    users = User.objects.all()
    serializer = UserSerializer(users, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getUser(request , pk):
    user = User.objects.get(id=pk)
    serializer = UserSerializer(user, many=False)
    return Response(serializer.data)

@api_view(['POST'])
def createUser(request):
    data = request.data
    try:

        if User.objects.filter(email=data['email']).exists():
            return Response({'error': 'User with this email already exists'}, status=status.HTTP_400_BAD_REQUEST)
        
        if User.objects.filter(username=data['username']).exists():
            return Response({'error': 'User with this username already exists'}, status=status.HTTP_400_BAD_REQUEST)
        
        user = User.objects.create_user(
            email=data['email'],
            username=data['username'],
            password=data['password'],
            name=data.get('name', ''),
            lastname=data.get('lastname', ''),
            date_of_birth=data.get('date_of_birth', None)
        )
        serializer = UserSerializer(user, many=False)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    except KeyError as e:
        return Response({'error': f'Missing required field: {str(e)}'}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['PUT'])
def updateUser(request, pk):
    try:
        user = User.objects.get(id=pk)
    except User.DoesNotExist:
        return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

    if request.user != user and not request.user.is_staff:
        return Response({'error': 'You can only update your own account'}, status=status.HTTP_403_FORBIDDEN)

    data = request.data.copy()
    password = data.pop('password', None)


    serializer = UserSerializer(user, data=data, partial=True)
    if serializer.is_valid():
        serializer.save()

        if password:
            user.set_password(password)
            user.save()
        return Response(serializer.data)
    else:
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['DELETE'])
def deleteUser(request, pk):
    try:
        user = User.objects.get(id=pk)

        if user != request.user and not request.user.is_staff:
            return Response({'error': 'You can only delete your own account'}, status=status.HTTP_403_FORBIDDEN)
        
        user.delete()
        return Response({'message': 'User deleted successfully'}, status=status.HTTP_204_NO_CONTENT)
    except User.DoesNotExist:
        return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

#Posts Views


@api_view(['GET'])
def getPosts(request):
    posts = Post.objects.all().order_by('-created_at')
    serializer = PostSerializer(posts, many=True)
    return Response(serializer.data)


@api_view(['GET'])
def getPost(request, pk):
    try:
        post = Post.objects.get(id=pk)
        serializer = PostSerializer(post, many=False)
        return Response(serializer.data)
    except Post.DoesNotExist:
        return Response({'error': 'Post not found'}, status=status.HTTP_404_NOT_FOUND)

@api_view(['POST'])
def createPost(request):
    data = request.data
    try:
        post = Post.objects.create(
            user=request.user,
            event_id=data.get('event_id', None),
            content=data['content']
        )
        serializer = PostSerializer(post, many=False)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    except KeyError as e:
        return Response({'error': f'Missing required field: {str(e)}'}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['PUT'])
def updatePost(request, pk):
    try:
        post = Post.objects.get(id=pk)
    except Post.DoesNotExist:
        return Response({'error': 'Post not found'}, status=status.HTTP_404_NOT_FOUND)

    if post.user != request.user and not request.user.is_staff:
        return Response({'error': 'You can only update your own posts'}, status=status.HTTP_403_FORBIDDEN)

    serializer = PostSerializer(post, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['DELETE'])
def deletePost(request, pk):
    try:
        post = Post.objects.get(id=pk)
        
        if post.user != request.user:
            return Response({'error': 'You can only delete your own posts'}, status=status.HTTP_403_FORBIDDEN)
        
        post.delete()
        return Response({'message': 'Post deleted successfully'}, status=status.HTTP_204_NO_CONTENT)
    except Post.DoesNotExist:
        return Response({'error': 'Post not found'}, status=status.HTTP_404_NOT_FOUND)

@api_view(['POST'])
def likePost(request, pk):
    try:
        post = Post.objects.get(id=pk)
        post.num_likes += 1
        post.save()
        return Response({'num_likes': post.num_likes})
    except Post.DoesNotExist:
        return Response({'error': 'Post not found'}, status=status.HTTP_404_NOT_FOUND)
    

#Comments Views

@api_view(['GET'])
def getComments(request):
    comments = Comment.objects.all().order_by('-created_at')
    serializer = CommentSerializer(comments, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getComment(request, pk):
    try:
        comment = Comment.objects.get(id=pk)
        serializer = CommentSerializer(comment, many=False)
        return Response(serializer.data)
    except Comment.DoesNotExist:
        return Response({'error': 'Comment not found'}, status=status.HTTP_404_NOT_FOUND)


@api_view(['POST'])
def createComment(request):
    data = request.data
    try:
        comment = Comment.objects.create(
            user=request.user,
            post_id=data['post_id'],
            content=data['content']
        )
        serializer = CommentSerializer(comment, many=False)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    except KeyError as e:
        return Response({'error': f'Missing required field: {str(e)}'}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['PUT'])
def updateComment(request, pk):
    try:
        comment = Comment.objects.get(id=pk)
    except Comment.DoesNotExist:
        return Response({'error': 'Comment not found'}, status=status.HTTP_404_NOT_FOUND)

    if comment.user != request.user and not request.user.is_staff:
        return Response({'error': 'You can only update your own comments'}, status=status.HTTP_403_FORBIDDEN)

    serializer = CommentSerializer(comment, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['DELETE'])
def deleteComment(request, pk):
    try:
        comment = Comment.objects.get(id=pk)
        
        if comment.user != request.user:
            return Response({'error': 'You can only delete your own comments'}, status=status.HTTP_403_FORBIDDEN)
        
        comment.delete()
        return Response({'message': 'Comment deleted successfully'}, status=status.HTTP_204_NO_CONTENT)
    except Comment.DoesNotExist:
        return Response({'error': 'Comment not found'}, status=status.HTTP_404_NOT_FOUND)



#Event Favorites Views

@api_view(['GET'])
def getFavorites(request):
    favorites = EventFavorite.objects.filter(user=request.user).order_by('-saved_at')
    serializer = EventFavoriteSerializer(favorites, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getFavorite(request, pk):
    try:
        favorite = EventFavorite.objects.get(id=pk)
        serializer = EventFavoriteSerializer(favorite, many=False)
        return Response(serializer.data)
    except EventFavorite.DoesNotExist:
        return Response({'error': 'Favorite not found'}, status=status.HTTP_404_NOT_FOUND)


@api_view(['POST'])
def createFavorite(request):
    data = request.data
    try:

        if EventFavorite.objects.filter(user=request.user, event_id=data['event_id']).exists():
            return Response({'error': 'Event already in favorites'}, status=status.HTTP_400_BAD_REQUEST)
        
        favorite = EventFavorite.objects.create(
            user=request.user,
            event_id=data['event_id']
        )
        serializer = EventFavoriteSerializer(favorite, many=False)
        if serializer.is_valid():
            serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    except KeyError as e:
        return Response({'error': f'Missing required field: {str(e)}'}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['DELETE'])
def deleteFavorite(request, pk):
    try:
        favorite = EventFavorite.objects.get(id=pk)
        
        if favorite.user != request.user:
            return Response({'error': 'You can only delete your own favorites'}, status=status.HTTP_403_FORBIDDEN)
        
        favorite.delete()
        return Response({'message': 'Favorite removed successfully'}, status=status.HTTP_204_NO_CONTENT)
    except EventFavorite.DoesNotExist:
        return Response({'error': 'Favorite not found'}, status=status.HTTP_404_NOT_FOUND)


#Photos Views

@api_view(['GET'])
def getPhoto(request, pk):
    try:
        photo = Photo.objects.get(id=pk)
        # Pass request context to serializer
        serializer = PhotoSerializer(photo, many=False, context={'request': request})
        return Response(serializer.data)
    except Photo.DoesNotExist:
        return Response({'error': 'Photo not found'}, status=status.HTTP_404_NOT_FOUND)

@api_view(['GET'])
def getPhotos(request):
    photos = Photo.objects.all()
    serializer = PhotoSerializer(photos, many=True, context={'request': request})
    return Response(serializer.data)

@api_view(['POST'])
def createPhoto(request):
    try:
        data = request.data
        content_type = data.get('content_type')
        
        if content_type == 'event':
            if Photo.objects.filter(event_id=data['event_id']).count() >= 10:
                return Response({'error': 'Maximum 10 photos per event'}, status=status.HTTP_400_BAD_REQUEST)
            
            photo = Photo.objects.create(
                content_type=content_type,
                event_id=data['event_id'],
                image=request.FILES['image']
            )
        elif content_type == 'post':
            if Photo.objects.filter(post_id=data['post_id']).count() >= 10:
                return Response({'error': 'Maximum 10 photos per post'}, status=status.HTTP_400_BAD_REQUEST)
            
            photo = Photo.objects.create(
                content_type=content_type,
                post_id=data['post_id'],
                image=request.FILES['image']
            )
        else:
            return Response({'error': 'Invalid content_type'}, status=status.HTTP_400_BAD_REQUEST)
        
        serializer = PhotoSerializer(photo, many=False)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    except KeyError as e:
        return Response({'error': f'Missing required field: {str(e)}'}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)



@api_view(['DELETE'])
def deletePhoto(request, pk):
    try:
        photo = Photo.objects.get(id=pk)
        
        if photo.event and photo.event.creator != request.user:
            return Response({'error': 'You can only delete photos from your own events'}, status=status.HTTP_403_FORBIDDEN)
        elif photo.post and photo.post.user != request.user:
            return Response({'error': 'You can only delete photos from your own posts'}, status=status.HTTP_403_FORBIDDEN)
        
        photo.delete()
        return Response({'message': 'Photo deleted successfully'}, status=status.HTTP_204_NO_CONTENT)
    except Photo.DoesNotExist:
        return Response({'error': 'Photo not found'}, status=status.HTTP_404_NOT_FOUND)