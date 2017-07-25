class CentralRegion
  def id
    nil
  end

  def name
    I18n.t('activerecord.attributes.central_region.name')
  end

  def short_name
    I18n.t('activerecord.attributes.central_region.short_name')
  end

  def locative
    I18n.t('activerecord.attributes.central_region.locative')
  end

  def slug
    ''
  end

  def long_slug
    ''
  end

  def image
    nil
  end

  def header_image
    nil
  end

  def parents
    []
  end

  def parent
    nil
  end

  def parent_id
    nil
  end

  def child_regions
    []
  end

  def subbranch_ids
    []
  end
end
