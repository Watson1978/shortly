require 'sinatra'
require 'base62-rb'
require 'ilios'

Ilios::Cassandra.config = {
  hosts: ['127.0.0.1'],
  keyspace: 'ilios',
}

get '/' do
  <<-HTML
  <form action="/regist" method="post">
    <input type="text" name="url" />
    <input type="submit" value="submit" />
  </form>
  HTML
end

get '/url/:id' do
  id = params[:id]

  session = Ilios::Cassandra.session
  statement = session.prepare("SELECT * FROM ilios.shortly WHERE id = ?")
  statement.bind({id: id})
  result = session.execute(statement)

  url = ''
  result.each do |row|
    url = row[1]
  end
  url
end

post '/regist' do
  url = params[:url]
  url_for_base62 = url.delete("^(0-9)|(a-z)|(A-Z)")
  id = Base62.decode(url_for_base62)

  session = Ilios::Cassandra.session
  statement = session.prepare("INSERT INTO ilios.shortly (id, url) VALUES (?, ?)")
  statement.bind({id: id.to_s, url: url})
  session.execute(statement)

  id.to_s
end