@account_base_url = "http://#{request.host_with_port}/accounts/#{@account.login}#{all_posts_path}" if @account
@base_url = "http://#{request.host_with_port}#{all_posts_path}"

atom_feed do |feed|
  feed.instruct!
  feed.rss do
    if @account.present? && @account.posts.count > 0
      xml << render(partial: 'posts/account_header.atom.builder')
    elsif @account.present? && @account.posts.count == 0
      xml << render(partial: 'posts/account_header.atom.builder')
    else
      xml.channel do
        feed.title "Recent Posts | OpenHub"
        feed.link @base_url if params[:query].blank? && params[:sort].blank?
        feed.link @base_url + "?query=#{params[:query]}&sort=#{params[:sort]}" if params[:query].present? && params[:sort].present?
        feed.language 'en-us'
        feed.ttl 60
        xml << render(partial: 'posts/posts.atom.builder', collection: @posts)
      end
    end
  end
end
