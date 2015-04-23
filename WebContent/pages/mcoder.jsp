<%@page contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>SB Admin 2 - Bootstrap Admin Theme</title>

    <!-- Bootstrap Core CSS -->
    <link href="../bower_components/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="../bower_components/metisMenu/dist/metisMenu.min.css" rel="stylesheet">

    <!-- Timeline CSS -->
    <link href="../dist/css/timeline.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="../dist/css/sb-admin-2.css" rel="stylesheet">

    <!-- Morris Charts CSS -->
    <link href="../bower_components/morrisjs/morris.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="../bower_components/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

	<script src="http://code.jquery.com/jquery-1.7.0.min.js"></script>
 	<script src="json2.js"></script>
 	
	<script type="text/javascript">
		jQuery.support.cors = true; //크로스 도메인 허용		
		//var ServletIp = 'localhost'; // Server IP address
		var ServletPort = '8082'; // My ebserver port
		var repeat;
	 		
		// 시작함수-------------------------------------------------------------------------------------
		window.onload = function(){				
			$('#OutputKey').val('test-transcoded-1');
			$('#PresetId').val('webm');			
			$('#progressbar1').width('0%');
		};
		
		// Init함수
		$(document).ready(function(){
			
			// 1. Job Create.
			$('#CreateJobBtn').click(function(){
				var requestUrl = 'http://localhost:' + ServletPort + '/v1/jobs';
				var requestBody = JSON.stringify(createJobJsonData, null, 4); // object to json 	
				requestPost(requestBody, requestUrl); 		 	
			});	

		});	 	
		
		// POST방식으로 서블릿에 JSON 데이터 전송------------------------------------------------------- 
  		function requestPost(requestBody, requestUrl){		
			
   			$.ajax({  				
  				url : encodeURI("http://localhost:8080/motie/motieApi?url=" + requestUrl),
  				contentType : "application/json; charset=utf-8",
  				data : requestBody,
  				type : 'POST',
  				success : function(data) {
  					jobCreateProcess(data); 					 
  				},
  				error : function(data, status, er) {
  					alert("status : " + status + "\n error msg :" + er);
  				}
  			}); 
		}; 
		
		function requestGet(responseForm, requestUrl) {
	 
			$.ajax({
				url : encodeURI("http://localhost:8080/motie/motieApi"),
				type : 'GET',
				data : 'url=' + requestUrl,
				success : function(data) {
					jobListProcess(data);
				},
				error : function(data, status, er) {
					alert("status : " + status + "\n error msg :" + er);
				}
			});
		};
		
		function jobCreateProcess(str){			
			$('#jobCreateState').text("1");
									
			var list= $.parseJSON(str);
			repeat = setInterval(function(){				
				// 2. Job List
 				var requestUrl = "http://localhost:" + ServletPort + "/v1/jobs/" + list.Job.Id;
				requestGet($('#ProcessingState'), requestUrl);				
 								
			}, 1000);								
		};
		
		function jobListProcess(str){
			$('#jobCreateState').text("0");
		 		
			var list = $.parseJSON(str);			
			var status = list.Job.Outputs[0].Status;
			
			if (status != "Complete"){
				$('#ProcessingState').text(status);
				$('#progressbar1').css('width',status + '%');
			}
			else {
				$('#ProcessingState').text("100");
				$('#Completed').text("1");
				$('#progressbar1').css('width','100%');
				clearInterval(repeat);
			}  
		}; 
		// ----------------------------------------------------------------------------------------
						
	</script>
	
	<script type="text/javascript">
	
	/* jobCreate json data */
	var createJobJsonData = 
		{
			Input: {					
	        	Url : './test.mp4'
	        },
	        OutputUrlPrefix : './media',	        	
			Outputs : [{
					Key : 'test-transcoded-1',
					ThumbnailPattern : '{key}_{resolution}_{count}',
					PresetId : 'webm',			
					Captions : {
						CaptionSources : [{
								Url : './test.smi'
							}]		
					}
				}, {
					Key : 'test-transcoded-2',
					ThumbnailPattern : '{key}_{resolution}_{count}',
					PresetId : 'm4a'
				} 
			]
	    };
	
	var jobCreateJsonString = "{'Input':{'Url':'./test.mp4'},'OutputUrlPrefix':'./media','Outputs':[{'Key':'test-transcoded-1','ThumbnailPattern':'{key}_{resolution}_{count}','PresetId':'webm','Captions':{'CaptionSources':[{'Url':'./test.smi'}]}},{'Key':'test-transcoded-2','ThumbnailPattern':'{key}_{resolution}_{count}','PresetId':'m4a'}]}";
	requestBody = jobCreateJsonString.replace(/'/gi, "\"");
	</script>

</head>

<body>

    <div id="wrapper">

		<%@include file="navigation.html" %>
        
        <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Mcoder </h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-primary">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                    <div>Submitted</div>
                                </div>
                                <div class="col-xs-9 text-right">
                                    <div class="huge" id="jobCreateState">0</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-yellow">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                    <div>Processing</div>
                                </div>
                                <div class="col-xs-9 text-right">
                                    <div class="huge" id="ProcessingState">0</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-green">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                    <div>Completed</div>
                                </div>
                                <div class="col-xs-9 text-right">
                                    <div class="huge" id="Completed">0</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-red">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                    <div>Failed</div>
                                </div>
                                <div class="col-xs-9 text-right">
                                    <div class="huge" id="Failed">0</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <i class="fa fa-navicon fa-fw"></i> Processing
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="col-lg-12">
                                        <span class="pull-left"><label>Output Key : </label> output.mp4</span>
                                    </div>
                                    <div class="col-lg-12">
                                        <span class="pull-left"><label>Start Time : </label> 2015-04-08 14:48:00</span>
                                    </div>
                                    <div class="col-lg-12">
                                        <span class="pull-left"><label>Processing : </label> 100%</span>
                                    </div>
                                    
                                    <!-- 프로그레스바 -->
                                    <div>
                                    	<h1 id="percentage"/>
                                    </div>
						            <div>
	                                    <p>
	                                        <strong>Task 1</strong>
	                                        <span class="pull-right text-muted" id="complete">40% Complete</span>
	                                    </p>
	                                    <div class="progress progress-striped active">
	                                        <div id="progressbar1" class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width:5%">
	                                            <span class="sr-only">40% Complete (success)</span>
                                        	</div>
                                    	</div>
                                	</div> 
                                	<!-- 프로그레스바 -->
                                </div>
                            </div>
                        </div>
                        <!-- .panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-8 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <i class="fa fa-navicon fa-fw"></i> Create New Job
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-6">
                                    <!-- <form role="form" action="fileFormOk.jsp" method="post" enctype="multipart/form-data" > -->
                                    <form role="form">
                                        <div class="form-group">
                                            <label>Text Input</label>
                                            <input type="file" name="file">
                                        </div>
                                        <div class="form-group">
                                            <label>Caption file</label>
                                            <input type="file">
                                        </div>
                                        <div class="form-group">
                                            <label>Output Key</label>
                                            <input class="form-control" id="OutputKey">
                                        </div>
                                        <div class="form-group">
                                            <label>Preset ID</label>
                                            <input class="form-control" id="PresetId">
                                        </div>
                                        <button type="button" id="CreateJobBtn" class="btn btn-default">Job Create.</button>
                                        <button type="submit" class="btn btn-default">Submit Button</button>
                                        <button id="JobListBtn" type="reset" class="btn btn-default">Reset Button</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <!-- .panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-8 -->
            </div>
            <!-- /.row -->
        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->

    <!-- jQuery -->
    <script src="../bower_components/jquery/dist/jquery.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="../bower_components/bootstrap/dist/js/bootstrap.min.js"></script>

    <!-- Metis Menu Plugin JavaScript -->
    <script src="../bower_components/metisMenu/dist/metisMenu.min.js"></script>

    <!-- Morris Charts JavaScript -->
    <script src="../bower_components/raphael/raphael-min.js"></script>
    <script src="../bower_components/morrisjs/morris.min.js"></script>
    <script src="../js/morris-data.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="../dist/js/sb-admin-2.js"></script>
	
</body>

</html>
