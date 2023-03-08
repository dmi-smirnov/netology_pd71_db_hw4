
-- 1. Количество исполнителей в каждом жанре.
SELECT m_g.name AS genre_name, COUNT(m_a_g.musical_artist_id) AS artist_count
  FROM musical_genre AS m_g
       INNER JOIN musical_artist_genre AS m_a_g
       ON m_g.id = m_a_g.musical_genre_id
 GROUP BY genre_name;

-- 2. Количество треков, вошедших в альбомы 2019–2020 годов.
SELECT COUNT(*) AS from_2019_to_2020_albums_tracks
  FROM musical_track AS m_t
       INNER JOIN musical_album AS m_a
       ON m_t.musical_album_id = m_a.id
          AND m_a.year_of_release BETWEEN 2019 AND 2020;

-- 3. Средняя продолжительность треков по каждому альбому.
SELECT m_a.name AS album_name, AVG(m_t.duration)
  FROM musical_album AS m_a
       INNER JOIN musical_track AS m_t
       ON m_a.id = m_t.musical_album_id
 GROUP BY m_a.name;

-- 4. Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT name AS artist_has_no_album_in_2020
  FROM musical_artist
 WHERE id NOT IN (SELECT m_al_ar.musical_artist_id
                FROM musical_album AS m_al
                     INNER JOIN musical_album_artist AS m_al_ar
                     ON m_al.id = m_al_ar.musical_album_id
                        AND m_al.year_of_release = 2020)
 ORDER BY name;

-- 5. Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).
SELECT m_c.name AS music_collection_with_ray_charles
  FROM music_collection AS m_c
       INNER JOIN musical_track_collection AS m_t_c
       ON m_c.id = m_t_c.music_collection_id

       INNER JOIN musical_track AS m_t
       ON m_t_c.musical_track_id = m_t.id

       INNER JOIN musical_album AS m_al
       ON m_t.musical_album_id = m_al.id

       INNER JOIN musical_album_artist AS m_al_ar
       ON m_al.id = m_al_ar.musical_album_id

       INNER JOIN musical_artist AS m_ar
       ON m_al_ar.musical_artist_id = m_ar.id
          AND m_ar.name = 'Ray Charles';

-- 6. Названия альбомов, в которых присутствуют исполнители более чем одного жанра.
-- вариант без вложенного запроса:
SELECT m_al.name AS multigenre_artist_album_name
  FROM musical_album AS	m_al
       INNER JOIN musical_album_artist AS m_al_ar
       ON m_al.id = m_al_ar.musical_album_id 
       
       INNER JOIN musical_artist AS m_ar
       ON m_al_ar.musical_artist_id = m_ar.id
       
       INNER JOIN musical_artist_genre AS m_ar_g
       ON m_ar.id = m_ar_g.musical_artist_id
 GROUP BY multigenre_artist_album_name
HAVING COUNT(m_ar_g.musical_genre_id) > 1
 ORDER BY multigenre_artist_album_name;
-- вариант со вложенным запросом:
SELECT m_al.name AS multigenre_artist_album_name
  FROM musical_album AS	m_al
       INNER JOIN musical_album_artist AS m_al_ar
       ON m_al.id = m_al_ar.musical_album_id
 WHERE m_al_ar.musical_artist_id IN (SELECT musical_artist_id
                                       FROM musical_artist_genre
                                      GROUP BY musical_artist_id
                                     HAVING COUNT(musical_genre_id) > 1)
 ORDER BY multigenre_artist_album_name;

-- 7. Наименования треков, которые не входят в сборники.
SELECT name AS not_in_collection_track_name
  FROM musical_track
 WHERE id NOT IN (SELECT DISTINCT musical_track_id
                    FROM musical_track_collection);

-- 8. Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.
SELECT m_ar.name AS shortest_track_artist_name
  FROM musical_track AS m_t
       INNER JOIN musical_album_artist AS m_al_ar
       ON m_t.musical_album_id = m_al_ar.musical_album_id
       
       INNER JOIN musical_artist AS m_ar
       ON m_al_ar.musical_artist_id = m_ar.id
 WHERE m_t.duration = (SELECT MIN(duration)
                         FROM musical_track)
 ORDER BY shortest_track_artist_name;

-- 9. Названия альбомов, содержащих наименьшее количество треков.
SELECT m_al.name AS min_track_count_album_name
  FROM (SELECT m_t.musical_album_id AS album_id, COUNT(m_t.id) AS track_count
          FROM musical_track AS m_t
         GROUP BY album_id) AS musical_album_track_count

       INNER JOIN musical_album AS m_al
       ON musical_album_track_count.album_id = m_al.id
 WHERE track_count = (SELECT MIN(track_count)
                        FROM (SELECT m_t.musical_album_id AS album_id, COUNT(m_t.id) AS track_count
                                FROM musical_track AS m_t
                               GROUP BY album_id) AS musical_album_track_count);


