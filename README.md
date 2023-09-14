# install
```
brew install cql cassandra cassandra-cpp-driver
```

# 準備
```
CREATE TABLE IF NOT EXISTS ilios.shortly (
  id text,
  url text,
  PRIMARY KEY (id)
) WITH compaction = { 'class' : 'LeveledCompactionStrategy' }
AND gc_grace_seconds = 691200;
```

# 起動
```
ruby shortly.rb
```