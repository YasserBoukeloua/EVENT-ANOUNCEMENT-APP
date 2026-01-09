from django.core.management.base import BaseCommand
from EventApp.models import Post, User, Event


class Command(BaseCommand):
    help = 'Create sample posts for events'

    def handle(self, *args, **options):
        posts_data = [
            {
                'user_id': 1,
                'event_id': 1,
                'content': "Excited for the Forsa Hackathon! Can't wait to build something amazing with my team. Who else is participating? 🚀"
            },
            {
                'user_id': 2,
                'event_id': 1,
                'content': "Just registered for Forsa Hackathon! Looking forward to meeting fellow developers and working on innovative projects."
            },
            {
                'user_id': 3,
                'event_id': 3,
                'content': "The Tech Conference is going to be huge this year! Speakers from top tech companies will be presenting. Don't miss it!"
            },
            {
                'user_id': 1,
                'event_id': 4,
                'content': "AI Workshop 2026 is a must-attend for anyone interested in machine learning. We'll be covering LLMs and computer vision hands-on."
            },
            {
                'user_id': 3,
                'event_id': 5,
                'content': "Startup Pitch Night is your chance to showcase your idea to real investors. Start preparing your pitch now! 💡"
            },
        ]

        created_count = 0
        for post_data in posts_data:
            try:
                user = User.objects.get(id=post_data['user_id'])
                event = Event.objects.get(id=post_data['event_id'])
                
                post, created = Post.objects.get_or_create(
                    user=user,
                    event=event,
                    content=post_data['content']
                )
                
                if created:
                    created_count += 1
                    self.stdout.write(self.style.SUCCESS(f'Created post: {post.content[:50]}...'))
                else:
                    self.stdout.write(self.style.WARNING(f'Post already exists: {post.content[:50]}...'))
            except User.DoesNotExist:
                self.stdout.write(self.style.ERROR(f'User {post_data["user_id"]} not found'))
            except Event.DoesNotExist:
                self.stdout.write(self.style.ERROR(f'Event {post_data["event_id"]} not found'))

        self.stdout.write(self.style.SUCCESS(f'\nCreated {created_count} new posts'))
