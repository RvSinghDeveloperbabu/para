class Para.NestedManyField
  constructor: (@$field) ->
    @$fieldsList = @$field.find('.fields-list')

    @initializeOrderable()
    @initializeCocoon()

  initializeOrderable: ->
    @orderable = @$field.hasClass('orderable')
    return unless @orderable

    @$fieldsList.sortable
      handle: '.order-anchor'
      forcePlaceholderSize: true

    @$fieldsList.on('sortupdate', $.proxy(@sortUpdate, this))

  sortUpdate: (e, ui) ->
    @$fieldsList.find('.form-fields').each (i, el) ->
      $(el).find('.resource-position-field').val(i)

  initializeCocoon: ->
    @$fieldsList.on 'cocoon:after-insert', $.proxy(@afterInsertField, this)

  afterInsertField: (e, $element) ->
    if ($collapsible = $element.find('[data-open-on-insert="true"]')).length
      @openInsertedField($collapsible)

    if @orderable
      @$fieldsList.sortable('destroy')
      @initializeOrderable()

    if ($redactor = $element.find('[data-redactor]')).length
      $redactor.simpleFormRedactor()

    if ($selectize = $element.find('[data-selectize]'))
      $selectize.simpleFormSelectize()

    if ($slider = $element.find('[data-slider]'))
      $slider.simpleFormSlider()

  openInsertedField: ($field) ->
    $target = $($field.attr('href'))
    $target.collapse('show').on 'shown.bs.collapse', ->
      $.scrollTo($target, 200)
      $target.find('input, select').eq('0').focus()


$(document).on 'page:change', ->
  $('.nested-many-field').each (i, el) -> new Para.NestedManyField($(el))
