pages = %w[Awards Biography Contact]
pages.each do |p|
  Page.create(name: p, permalink: p.downcase, content: 'initial content')
end
