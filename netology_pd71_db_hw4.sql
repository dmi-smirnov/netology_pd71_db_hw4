
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
SELECT m_ar.name AS artist_has_no_album_in_2020
  FROM musical_album AS m_al
       INNER JOIN musical_album_artist AS m_al_ar
       ON m_al.id = m_al_ar.musical_album_id
          AND m_al.year_of_release != 2020
       
       INNER JOIN musical_artist AS m_ar
       ON m_al_ar.musical_artist_id = m_ar.id;


-- 5. Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).
-- 6. Названия альбомов, в которых присутствуют исполнители более чем одного жанра.
-- 7. Наименования треков, которые не входят в сборники.
-- 8. Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.
-- 9. Названия альбомов, содержащих наименьшее количество треков.
