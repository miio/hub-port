# dnd.coffee

data = []

add = (files, $files) ->
  unless files && files[0]
    unless FileReader
      alert "お使いのブラウザは未対応です。"
    return false
  
  Array::forEach.call files, (file) ->
    data_index = data.push
      name: file.name
      type: file.type
    
    fr = new FileReader
    fr.onload = ->
      unless @.readyState == 2
        alert "ファイルの読み込みに失敗しました"
      data[--data_index].data_uri = @.result
      # リンク追加
      $files.find("li").eq(data_index).html '<a href="' + @.result + '" target="_brank">' + file.name + '</a>'
    fr.readAsDataURL file
  
  list = data.map (file) ->
    file_name =
      if file.data_uri?
      then '<a href="' + file.data_uri + '" target="_brank">' + file.name + '</a>'
      else file.name
    '<li>' + file_name + '</li>'
  
  # ファイル一覧更新
  $files.html list.join ""

$ ->
  $files = $ "#files"
  
  $("#user_repo_work_blob").change ->
    add this.files, $files
  
  $dropper = $ "#dropper"
  
  $dropper.bind "drop", (e) ->
    add e.originalEvent.dataTransfer.files, $files
    $(@).css "z-index": 0
    $(@).css "background-color": "transparent"
    false
  .bind "dragenter", ->
    $(@).css "z-index": 1000
    $(@).css "background-color": "rgba(100, 100, 100, 0.2)"
    false
  .bind "dragover", ->
    false
  .bind "dragleave", ->
    $(@).css "z-index": 0
    $(@).css "background-color": "transparent"
    false
  
  return
