require('sinatra')
require('sinatra/reloader')
require('pg')
require('./lib/book')
require('./lib/patron')
require('./lib/author')
also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => 'library_catalog_test'})

get('/') do
  @header = "Library Catalog"
  @patrons = Patron.all()
  erb(:index)
end

post('/') do
  @header = "Library Catalog"
  patron = Patron.new({:last_name => params.fetch('last-name'), :first_name => params.fetch('first-name'), :id => nil})
  patron.save()
  @patrons = Patron.all()
  erb(:index)
end

delete('/') do
  @header = "Library Catalog"
  patron = Patron.find(params.fetch('patron-id').to_i())
  patron.delete()
  @patrons = Patron.all()
  erb(:index)
end

get('/:id/edit') do
  patron = Patron.find(params.fetch('id').to_i())
  @header = "Edit #{patron.last_name()}, #{patron.first_name()}"
  @id = params.fetch('id')
  erb(:update_patron)
end

patch('/') do
  @header = "Library Catalog"
  patron = Patron.find(params.fetch('patron-id').to_i())
  patron.update({:last_name => params.fetch('last-name'), :first_name => params.fetch('first-name')})
  @patrons = Patron.all()
  erb(:index)
end

get('/new_patron') do
  @header = "Add Patron"
  erb(:patron_form)
end