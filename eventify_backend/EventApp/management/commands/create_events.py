from django.core.management.base import BaseCommand
from EventApp.models import Event, User, Photo
from datetime import date, timedelta
import random


class Command(BaseCommand):
    help = 'Create 5 professional events with all attributes'

    def handle(self, *args, **options):
        # Get admin user (ID 3)
        try:
            admin_user = User.objects.get(id=3)
        except User.DoesNotExist:
            self.stdout.write(self.style.ERROR('Admin user (ID 3) not found!'))
            return

        # Professional events data
        events_data = [
            {
                'title': 'International AI & Machine Learning Summit 2026',
                'description': 'Join world-renowned AI researchers and industry leaders for a 3-day summit exploring cutting-edge developments in artificial intelligence, deep learning, and neural networks. Features keynote speeches, hands-on workshops, poster sessions, and networking opportunities with top tech companies including Google, Microsoft, and OpenAI.',
                'date': date.today() + timedelta(days=45),
                'location': 'Algiers Convention Center, Algiers',
            },
            {
                'title': 'North Africa Startup & Entrepreneurship Forum',
                'description': 'The largest entrepreneurship event in North Africa bringing together 500+ startups, 100+ investors, and industry mentors. Pitch competitions with $50,000 in prizes, investor matchmaking sessions, startup exhibitions, and masterclasses on fundraising, scaling, and market expansion across MENA region.',
                'date': date.today() + timedelta(days=30),
                'location': 'Sheraton Hotel, Oran',
            },
            {
                'title': 'DevFest Algeria 2026 - Google Developer Conference',
                'description': 'Annual Google Developer Group conference featuring the latest in Android development, Flutter, Firebase, Google Cloud Platform, and Web technologies. 20+ technical sessions, codelabs, app reviews, and direct interaction with Google Developer Experts. Perfect for developers of all skill levels.',
                'date': date.today() + timedelta(days=60),
                'location': 'USTHB Campus, Bab Ezzouar, Algiers',
            },
            {
                'title': 'Cybersecurity & Digital Privacy Conference',
                'description': 'Essential conference for IT professionals and security enthusiasts covering ethical hacking, penetration testing, zero-trust architecture, cloud security, and GDPR compliance. Featuring live hacking demonstrations, CTF competitions, and certification prep workshops for CISSP and CEH.',
                'date': date.today() + timedelta(days=75),
                'location': 'Hilton Hotel, Constantine',
            },
            {
                'title': 'Women in Tech Algeria - Leadership Summit',
                'description': 'Empowering women in technology through inspiring talks from female tech leaders, career development workshops, mentorship matching, and networking sessions. Topics include breaking into tech, leadership skills, work-life balance, and building inclusive teams. Open to all genders who support diversity in tech.',
                'date': date.today() + timedelta(days=20),
                'location': 'Innovation Hub, Sidi Abdellah, Algiers',
            },
        ]

        created_count = 0
        for event_data in events_data:
            # Check if event with same title exists
            if not Event.objects.filter(title=event_data['title']).exists():
                event = Event.objects.create(
                    creator=admin_user,
                    title=event_data['title'],
                    description=event_data['description'],
                    date=event_data['date'],
                    location=event_data['location'],
                )
                created_count += 1
                self.stdout.write(self.style.SUCCESS(f'Created event: {event.title}'))
            else:
                self.stdout.write(self.style.WARNING(f'Event already exists: {event_data["title"]}'))

        self.stdout.write(self.style.SUCCESS(f'\nTotal events created: {created_count}'))
