require 'sinatra'
require 'tilt' # we need rdiscount too
require 'erb'

get '*' do
  page = params[:splat][0]
  redirect "/home" if page == "/"
  page_path = "#{FileUtils.pwd}/pages#{page}.md"
  if File.exists? page_path
    if params.keys.include? "edit"
      action = :edit
      content = File.read page_path
    else
      action = :show
      content = Tilt.new(page_path).render
    end
  else
    action = :edit
    content = ""
  end
  locals = {
    page: page,
    page_path: page_path,
    content: content
  }
  erb action, :locals => locals
end

post '*' do
  page = params[:splat][0]
  page_path = "#{FileUtils.pwd}/pages#{page}.md"
  content = params[:content]
  File.open(page_path, "w") do |file|
    file.write content
  end
  redirect page
end
