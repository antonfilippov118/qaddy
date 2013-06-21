$(document).ready(function(){
	get_webstores_ajax();
	get_data_ajax();
	
	$('.scope').click(function(){
		$('.scope').removeClass('selected');
		$(this).addClass('selected');
		$('#scope').val($(this).data('scope'));
		
		get_data_ajax();
		
	});
});

function get_data_ajax() {

	var params = $('#collection_selection').serializeArray();
	$.ajax({
        url: "/dashboard/get_order_statistics",
        type: 'POST',
		data: params,
        cache: false,
        success: function(html) {
			$('.index_as_table table tbody').html(html)
            
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
        

    });
};

function get_webstores_ajax() {
	var is_admin = $('#is_admin').val();
	$.ajax({
        url: "/dashboard/get_webstores?is_admin=" + is_admin + "&id=get_webstores",
        type: 'GET',
        cache: false,
        success: function(html) {
			$('#webstore_selector .dropdown_menu_list').html(html)
			$('#webstore_selector ul.dropdown_menu_list > li').click(function(){
				$('#webstore_id').val($(this).data('webstore-id'));
				$('#webstore_selector .dropdown_menu_button').text($(this).text());
				$(this).parent().find('li.selected').removeClass('selected');
				$(this).addClass('selected');
				get_data_ajax();
				
			})
            
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {

        }
        

    });
};
