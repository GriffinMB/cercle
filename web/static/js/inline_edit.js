$(function() {
  $('.inline-editable').each(function(index){
    var ele = $(this);
  
    if(ele.text() == "") {
      ele.addClass('inline-edit-empty');
    } else {
      ele.removeClass('inline-edit-empty');
    }
  
    ele.click(function(){
      ele.hide();
      var editContainer = $("<span class='editable-container'><form class='form-inline editableform'><div class='editable-input'></div><div class='editable-buttons'><button class='btn btn-primary btn-xs editable-submit'><i class='fa fa-check'></i></button><a class='btn btn-default btn-xs editable-cancel'><i class='fa fa-times'></i></a></div></form</span>");
      var inputElement;
      if (ele.data('input-type') == 'textarea'){
        inputElement = $("<textarea style='width:100%;height:80px;' ></textarea>");
        editContainer.find('.editable-container').css('display', 'block !important');
        editContainer.find('.editable-input').css('display', 'block');
        editContainer.find('.editable-input').append(inputElement);
      }
      else{
        inputElement = $("<input style='height: 25px;width: 125px;' class='form-control input-sm' type='text' />");
        editContainer.find('.editable-input').append(inputElement);
      }
  
      
      inputElement.val(ele.text());
      editContainer.find("form").submit(function(e){
        e.preventDefault();
  
        var params = {};
        params[ele.data('param-name')] = inputElement.val();
  
        $.ajax(ele.data('inline-editurl'), {
          type: ele.data('type'),
          data: params,
          success: function(xhr, st){
            ele.text(params[ele.data('param-name')]);
            editContainer.find('.editable-cancel').trigger('click');
          }
        })
      });
  
      editContainer.find('.editable-cancel').click(function(e){
        e.preventDefault();
        editContainer.remove();
        ele.show();
  
        if(ele.text() == "") {
          ele.addClass('inline-edit-empty');
        } else {
          ele.removeClass('inline-edit-empty');
        }
      });
  
      editContainer.insertAfter(ele);
    });
  });
});



