# app/helpers/application_helper.rb
module ApplicationHelper

  def pretty_boolean value
    if value.present?
      %{<span class="label label-success">#{ fa_icon 'check fw', text: 'Sim'}</span>}.html_safe
    else
      %{<span class="label label-danger">#{ fa_icon 'times fw', text: 'Não'}</span>}.html_safe
    end
  end

end

# VIEW
= pretty_boolean user.status