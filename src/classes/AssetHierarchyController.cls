public class AssetHierarchyController {
    @AuraEnabled
    public static List<AssetHierarchyNode> getAllAssetHierarchyRecords(){
        System.debug('Testing AssetHierarchyController.....');
        List<Asset_hierarchy__c> parentAsset=[select Id, Name, Asset_hierarchy__c from Asset_hierarchy__c where Asset_hierarchy__c=null];
        Map<Id,AssetHierarchyNode> nodes = new Map<Id,AssetHierarchyNode>();
        Set<Id> parentAssetId = new Set<Id>();
        for (Asset_hierarchy__c asset : parentAsset) {
            nodes.put(asset.Id, new AssetHierarchyNode(asset));
            parentAssetId.add(asset.Id);
        }
        while (parentAssetId.size() > 0) {
            Map<Id,Asset_hierarchy__c> subAsset =
                new Map<Id,Asset_hierarchy__c>([
                    select Id, Name, Asset_hierarchy__c from Asset_hierarchy__c where Asset_hierarchy__c IN :parentAssetId
                ]);
            
            parentAssetId = subAsset.keySet();
            
            for (Asset_hierarchy__c asset : subAsset.values()) {
                AssetHierarchyNode new_node = new AssetHierarchyNode(asset);
                nodes.put(asset.id, new_node);
                AssetHierarchyNode ref_node = nodes.get(asset.Asset_hierarchy__c);
                ref_node.children.add(new_node);
            }
        }
        //===========================================*********Sample Code*******===================================//
        List<AssetHierarchyNode> recordsToDisply=new List<AssetHierarchyNode>();
        Set<ID> subOrdinateId=new Set<ID>();
        for (Asset_hierarchy__c asset : parentAsset) {
            AssetHierarchyNode hN=nodes.get(asset.Id);
            List<AssetHierarchyNode> childNodes=hN.children;
            AssetHierarchyNode mainNode=new AssetHierarchyNode(asset);
            recordsToDisply.add(mainNode);
            for(AssetHierarchyNode hNChild:childNodes){
                AssetHierarchyNode gChild=nodes.get(hNChild.parent.id);
            }
        } 
        
        
        
        
        return nodes.values();  
    }  
    
    
    public class AssetHierarchyNode {
        @AuraEnabled
        public Asset_hierarchy__c parent{set;get;}
        @AuraEnabled
        public List<AssetHierarchyNode> children{set;get;}
        @AuraEnabled
        public String label{set;get;}
        @AuraEnabled
        public String name{set;get;}
        @AuraEnabled
        public boolean expanded{set;get;}
         @AuraEnabled
        public boolean disabled{set;get;}
        
        
        public  AssetHierarchyNode(Asset_hierarchy__c parent) {
            this.parent = parent;
            this.label=parent.Name;
            this.name=parent.Id;
            this.expanded=true;
            this.disabled=false;
            children = new List<AssetHierarchyNode>();
        }
        
    }
    
    
    @AuraEnabled
    public static AssetHierarchyNode getMainRoles(){
        AssetHierarchyNode rootNode;
        List<AssetHierarchyNode> rootNodeLst=new List<AssetHierarchyNode>();   
        List<Asset_hierarchy__c> parentAsset=[select Id, Name, Asset_hierarchy__c from Asset_hierarchy__c where Asset_hierarchy__c=null];
        Map<Id, Asset_hierarchy__c> hierarchyMap = new Map<Id, Asset_hierarchy__c>([select Id, Name, Asset_hierarchy__c from Asset_hierarchy__c where Asset_hierarchy__c!=null]);
        Map<Id, Asset_hierarchy__c> allHierarchyMap = new Map<Id, Asset_hierarchy__c>([select Id, Name, Asset_hierarchy__c from Asset_hierarchy__c]);
        
        Map<Id, AssetHierarchyNode> nodesMap = new Map<Id, AssetHierarchyNode>();
        System.debug('parentAsset:::'+parentAsset);
           for(integer i=0;i<parentAsset.size();i++){   
            rootNode = new AssetHierarchyNode(parentAsset[i]);
            nodesMap.put(parentAsset[i].Id, rootNode);
            AssetHierarchyNode currentNode;
            AssetHierarchyNode parentNode;
            for(Asset_hierarchy__c currentAsset :hierarchyMap.values()){
                if(!nodesMap.containsKey(currentAsset.Id)){
                    nodesMap.put(currentAsset.Id, new AssetHierarchyNode(currentAsset));
                }
                
                currentNode = nodesMap.get(currentAsset.Id);
                
                if(!nodesMap.containsKey(currentAsset.Asset_hierarchy__c)  ){
                    nodesMap.put(currentAsset.Asset_hierarchy__c, new AssetHierarchyNode(hierarchyMap.get(currentAsset.Asset_hierarchy__c)));
                }
                
                parentNode = nodesMap.get(currentAsset.Asset_hierarchy__c);
                parentNode.children.add(currentNode);
            }
            System.debug('rootNode:::'+rootNode);
            rootNodeLst.add(rootNode);
            System.debug('rootNode::'+rootNode);
        }
        return rootNode;
    }  
   
}