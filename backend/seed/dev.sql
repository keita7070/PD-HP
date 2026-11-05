INSERT INTO labs (id, name, professor, summary, location, core_time, seminar_schedule, equipment, contact)
VALUES
  ('sample-a', 'サンプルA研究室', '山田 太郎', '機械学習と画像処理の研究をしています。',
   '工学部1号館 301', '10:00〜17:00（平日）', '毎週水曜 13:30〜',
   ARRAY['GPUサーバ', '3Dプリンタ'], 'yamada@example.ac.jp'),
  ('sample-b', 'サンプルB研究室', '鈴木 花子', 'ネットワークと分散システムの研究室です。',
   '工学部2号館 405', 'なし（フレックス）', '隔週金曜 15:00〜',
   ARRAY['検証用サーバラック'], 'suzuki@example.ac.jp')
ON CONFLICT (id) DO NOTHING;
