# Cluster_File
**專題名稱:基於K8s的Quorum快速部屬工具**


## 第一階段一鍵部署7個節點私有鏈
>從quorum-examples的7nodes架在vm裡移植到k8s上面。

### 使用方式
`1.註冊google GKE https://cloud.google.com/kubernetes-engine/ `  
`2.git clone https://github.com/ArnoldQIU/restart.git`  
`3.kubectl create configmap node_default --from-file=./node_default`  
`4.kubectl create configmap controlscript --from-file=./controlscript`  
`5./one_deployment_node.sh`  

### 相關檔案
- `one_click_deployment.sh`：一鍵部署7節點腳本檔案
- `7nodes`：7個節點的固定資料
- `script`：腳本集合   


## 第二階段一鍵部署任意數節點私有鏈並控制
>從7個節點改成任意節點並控制它。

### 功能
1. Quick deployment N's node
2. Quick add N's node
3. Delete node
4. Change UI
5. Block generator

### 使用方式
`./one_click_control_node.sh`

### 相關檔案
- `one_click_deployment.sh`：：一鍵控制節點腳本檔案
- `node_default`：節點裡的固定資料
- `controlscript`：腳本集合  
(a)check_ip.sh:確認server_IP已分配    
(b)create_deployment.sh:創建k8s deploy，並建置好node架構  
(c)create_service.sh:創建k8s service，為每個pod建立service提供外部連接功能  
(d)copy_default.sh: 創建基本資料型式     
(e)generate_permissioned-noedes.sh  
(f)create_block:block產稱測試  
(g)deploy.sh: geth node  
(h)create_ui.sh:創建website_UI    


- `node`：節點的dockerfile  

## 節點失去連線&website斷掉  
### 使用方式  
-`./refresh_all_permissioned.sh 1 $NODE_END_NUMBER`  

## 第三方程式
- https://github.com/jpmorganchase/quorum  
- https://github.com/jpmorganchase/cakeshop

