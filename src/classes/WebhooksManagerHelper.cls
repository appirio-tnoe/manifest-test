public with sharing class WebhooksManagerHelper {

	static final Map<String, String> METADATA_TYPE_MAP = new Map<String, String> {
		'analyticsnapshot' 					 => 'AnalyticSnapshot',
		'cls' 						 					 => 'ApexClass',
		'component' 			 					 => 'ApexComponent',
		'page' 						 					 => 'ApexPage',
		'trigger' 				 					 => 'ApexTrigger',
		'approvalProcess'  					 => 'ApprovalProcess',
		'assignmentRules'  					 => 'AssignmentRules',
		'app'							 					 => 'CustomApplication',
		'customApplicationComponent' => 'CustomApplicationComponent',
		'labels'										 => 'CustomLabel',
		'object'										 => 'CustomObject',
		'objectTranslation'					 => 'CustomObjectTranslation',
		'weblink'										 => 'CustomPageWebLink',
		'site'											 => 'CustomSite',
		'tab'												 => 'CustomTab',
		'dashboard'									 => 'Dashboard',
		'datacategorygroup'					 => 'DataCategoryGroup',
		'document'									 => 'Document',
		'email'											 => 'EmailTemplate',
		'entitlementTemplate'				 => 'EntitlementTemplate',
		'flow'											 => 'Flow',
		'group'											 => 'Group',
		'homePageComponent'					 => 'HomePageComponent',
		'homePageLayout'						 => 'HomePageLayout',
		'layout'										 => 'Layout',
		'letter'										 => 'Letterhead',
		'permissionset'							 => 'PermissionSet',
		'portal'										 => 'Portal',
		'profile'										 => 'Profile',
		'queue'											 => 'Queue',
		'quickAction'								 => 'QuickAction',
		'remoteSite'								 => 'RemoteSiteSetting',
		'report'										 => 'Report',
		'reportType'								 => 'ReportType',
		'role'											 => 'Role',
		'resource'									 => 'StaticResource',
		'territory'									 => 'Territory',
		'workflow'									 => 'Workflow'
	};
	
	public static Manifest_Item__c createManifestItem(Map<String, String> miMap) {
    String filename = miMap.get('filepath').substringAfterLast('/');
    String apiName = filename == '' ? miMap.get('filepath') : filename.substringBefore('.');
    String fileExtension = filename.substringAfter('.');
    String type = METADATA_TYPE_MAP.get(fileExtension);
    Manifest_Item__c mi = new Manifest_Item__c(
        Name__c=apiName,
        Type__c=type == null ? 'Other' : type,
        Notes__c=miMap.get('notes'),
        Action__c=miMap.get('action'));

    String relatedTo = miMap.get('relatedTo');
    if (relatedTo.substring(0, 1).toLowerCase() == 's') { 
        mi.Story__c = [SELECT Id FROM Story__c WHERE Name = :relatedTo][0].id; 
    } else if (relatedTo.substring(0, 1).toLowerCase() == 'i') { 
        mi.Issue__c = [SELECT Id FROM Issue__c WHERE Name = :relatedTo][0].id; 
    }

    return mi;
	}
}