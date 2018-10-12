# gemfile
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'responders'

 # config/initializers/wicked_pdf.rb
  module WickedPdfHelper
  if Rails.env.development?
    if RbConfig::CONFIG['host_os'] =~ /linux/
      executable = RbConfig::CONFIG['host_cpu'] == 'x86_64' ?
'wkhtmltopdf_linux_x64' : 'wkhtmltopdf_linux_386'
    elsif RbConfig::CONFIG['host_os'] =~ /darwin/
      executable = 'wkhtmltopdf_darwin_386'
    else
      raise 'Invalid platform. Must be running linux or intel-based Mac OS.'
    end

    WickedPdf.config = { exe_path: "#{ENV['GEM_HOME']}/bin/wkhtmltopdf"}
  end
end


# controller - user_controller.rb
respond_to :html, :js, :pdf

def show
  @user = User.find params[:id]

  respond_to do |format|
    format.pdf do
      render pdf: "nome_do_arquivo",
             template: "users/show.pdf.erb",
             locals: {:user => @user}
    end
  end
end

# view - users/show.pdf.erb
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<h1><%= user.title %></h1>
<p><%= user.description %></p>
<p align="center"><%= wicked_pdf_image_tag 'logo.jpg' %></p>

# view url
= link_to user_path(user, format: :pdf), class: 'btn btn-primary btn-xs', \
    data: { toggle: 'tooltip', title: 'Gerar pdf' }  do
    => fa_icon 'file-pdf-o fw'
