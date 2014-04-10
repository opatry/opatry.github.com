include Nanoc::Helpers::Rendering
include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::Blogging

def age(dob)
  unless dob.nil?
    date = Date.today
    day_diff = date.day - dob.day
    month_diff = date.month - dob.month - (day_diff < 0 ? 1 : 0)
    date.year - dob.year - (month_diff < 0 ? 1 : 0)
  end
end

def get_pretty_date(note)
  # dimanche 9 mars 2014, 17h40
  attribute_to_time(note[:created_at]).strftime('%A %-d %B %Y, %kh%M')
end

def get_rss_date(note)
  # Fri, 25 May 2012 14:48:00 +0200
  attribute_to_time(note[:created_at]).strftime('%a, %d %b %Y %H:%M:%S %z')
end

def get_xml_schema_date(note)
  note[:created_at].to_iso8601_date
end

module NotesHelper

  def all_notes
    @items.select { |item| item[:kind] == 'note' }
  end

  def notes
    all_notes.sort_by { |note| attribute_to_time(note[:created_at]) }
  end

  def reverse_notes
    notes.reverse
  end
end

include NotesHelper

# from https://ecarmi.org/writing/next-previous-links-nanoc/
def previous_link
  notes_ = notes
  prev_article = notes_[notes_.index(@item) + 1]
  if prev_article.nil?
    '&laquo;&nbsp;&empty;'
  else
    title = prev_article[:title]
    html = "&laquo;&nbsp;#{title}"
    link_to(html, prev_article.reps[0], :class => "prev", :title => title)
  end
end

def next_link
  notes_ = notes
  idx = notes_.index(@item) - 1
  if idx < 0
    '&empty;&nbsp;&raquo;'
  else
    next_article = notes_[idx]
    title = next_article[:title]
    html = "#{title}&nbsp;&raquo;"
    link_to(html, next_article.reps[0], :class => "next", :title => title)
  end
end
