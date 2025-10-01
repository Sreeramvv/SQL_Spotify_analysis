#-------------------------------------------------SQL spotify project------------------------------------------------------
create table proj2.spotify(
Artist varchar(50),	
Track varchar(255),
Album varchar(255),
Album_type varchar(50),
Danceability float,
Energy float,
Loudness float,
Speechiness float,
Acousticness float,
Instrumentalness float,
Liveness float,
Valence float,
Tempo float,
Duration_min float,
Title varchar(255),
Channels varchar(255),
Views float,
Likes bigint,
Comments bigint,
Licensed boolean,
official_video boolean,
Stream	bigint,
EnergyLiveness float,
most_playedon varchar(50));

#checking if there is any null values
select * from proj2.spotify where  
Artist is null or
Track is null or
Album is null or
Album_type is null or
Danceability is null or
Energy is null or
Loudness is null or
Speechiness is null or
Acousticness is null or
Instrumentalness is null or
Liveness is null or
Valence is null or
Tempo is null or
Duration_min is null or
Title is null or
Channels is null or
Views is null or
Likes is null or
Comments is null or
Licensed is null or
official_video is null or
Stream is null or
EnergyLiveness is null or
most_playedon is null
;

select count(*) from proj2.spotify;
select *  from proj2.spotify;

#retrieve all the names  of all the tracks that have more than one billion streams
select * from proj2.spotify where stream > 1000000000;

#list the albums along with their respective artists
select Artist,Album from proj2.spotify;

#get the total number of comments for the tracks where licensed = True
select sum(Comments) as tot_number_of_comments from proj2.spotify where Licensed="TRUE";
-
#count the total number of the tracks by each artist
select artist,count(Track) as number_of_tracks from proj2.spotify group by artist; 

#count the avg Danceability of the tracks in each album
select Album,round(avg(Danceability),4) as avg_Danceability from proj2.spotify group by 1 order by 2 desc;

#find the top5 tracks with the highest energy values
select Track,Energy from proj2.spotify order by Energy desc limit 5;

#list all the tracks along the total views total likes of all the associated tracks
select Track,sum(Views) as tot_views from proj2.spotify group by Track;

#for each album, calculate the total views of all associated tracks
select Album,Track,sum(Views) as tot_views from proj2.spotify group by Album,Track;

#retrieve the track names that have been streamed on spotify more than youtube
select * from 
(select Track,most_playedon,
coalesce(sum(case when most_playedon="Spotify" then stream end) ,0) as streamed_on_spotify,
coalesce(sum(case when most_playedon="Youtube" then stream end), 0) as streamed_on_youtubes
from proj2.spotify
group by 1,2) as t1
where 
streamed_on_spotify > streamed_on_youtubes and streamed_on_youtubes <> 0;

#find the top 3 most viewed tracks for each artist using window fuction
with top3 as
(
select Artist,
Track,
sum(Views),
dense_rank() over (partition by Artist order by sum(Views) desc) as ranks 
from proj2.spotify 
group by 1,2 order by Artist asc,sum(Views) desc
)
select * from top3 where ranks<=3;

#write a query to find tracks where the Liveness is greater the avg
select Track,Liveness from proj2.spotify where ( select avg(Liveness) from proj2.spotify);


#using with clause to calculate the difference between the highest and lowest energy values for tracks in each album
with ss as
(
select Album,
max(Energy) as high,
min(Energy) as low 
from proj2.spotify
group by 1
)
select album, round(high - low,2) as energy_diff from ss order by energy_diff desc;


