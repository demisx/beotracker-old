$ -> 
  # Fix issue with holder.js placeholders not showing up until page reload when turbolinks are used
  $(document).bind 'page:change', ->
    Holder.run()