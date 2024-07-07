from django.conf import settings
from announcements.models import Announcement
from collections import deque

class AnnouncementQueue:
    def __init__(self):
        self.queue = deque()

    def queue_announcement(self, ann_id: str):
        self.queue.append(ann_id)
    
    def clear(self):
        self.queue.clear()

    def count(self):
        return len(self.queue)

    def process_announcement(self):
        if not self.queue:
            print("No announcements to process")
            return
        
        ann_id = self.queue.popleft()
        try:
            announcement = Announcement.objects.get(id=ann_id)
            print(f"SEND ANNOUNCEMENT {announcement.id}")
        except Announcement.DoesNotExist:
            print(f"Announcement with id {ann_id} not found")
        except Exception as e:
            print(f"Error processing announcement {ann_id}: {str(e)}")

ann_queue = AnnouncementQueue()
