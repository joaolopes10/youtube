from googleapiclient.discovery import build
import re
from datetime import datetime, timedelta


videos = []
hours_pattern = re.compile(r'(\d+)H')
minutes_pattern = re.compile(r'(\d+)M')
seconds_pattern = re.compile(r'(\d+)S')
total_seconds = 0


#get all the data
api_key = 'AIzaSyB2ml7mWVw-HTlJAMrQs8lj3yw1N1eF-f8'

youtube = build('youtube', 'v3', developerKey=api_key)

request = youtube.videos().list(
        part='snippet,statistics, contentDetails',
        chart="mostPopular",
        maxResults=50
    )
 
response = request.execute()

#Sort by relevant data: Views, id, title, durantion
def retrieve_relevante_data(list):
    global total_seconds
    for item in list['items']:
        #Get the seconds from duration
        duration = item['contentDetails']['duration']
        hours = hours_pattern.search(duration)
        minutes = minutes_pattern.search(duration)
        seconds = seconds_pattern.search(duration)  

        hours = int(hours.group(1)) if hours else 0
        minutes = int(minutes.group(1)) if minutes else 0
        seconds = int(seconds.group(1)) if seconds else 0
    
        video_seconds = timedelta(
            hours=hours,
            minutes=minutes,
            seconds=seconds
        ).total_seconds()

        total_seconds += video_seconds
             
        #save my relevante data
        videos.append(
            {             
                'views': int(item['statistics']['viewCount']),
                'id': item['id'],
                'title': item['snippet']['title'],
                'duration': timedelta(hours=hours,minutes=minutes,seconds=seconds)  
            }
        )

#call the funcion to sort the relevant data
retrieve_relevante_data(response)


print("5 most viewed videos: \n")

videos.sort(key=lambda vid: vid["views"], reverse=True)

for video in videos[:5]:
        print("Nº Views: ",video['views'], "Title: ", video['title'], "ID: ", video['id'])


print("\n5 longest videos: \n")

videos.sort(key=lambda vid: vid["duration"], reverse=True)

for video in videos[:5]:
        print("Duration: ",video['duration'], "Title: ", video['title'], "ID: ", video['id'])      

total_seconds = int(total_seconds)
minutes, seconds = divmod(total_seconds, 60)
hours, minutes = divmod(minutes, 60)

print("Sum number of views for all 50 videos: ", f'{hours}:{minutes}:{seconds}')



