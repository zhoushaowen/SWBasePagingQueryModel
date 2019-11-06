Pod::Spec.new do |s|

  s.name         = "SWBasePagingQueryModel"

  s.version      = "1.0.5"

  s.homepage      = 'https://github.com/zhoushaowen/SWBasePagingQueryModel'

  s.ios.deployment_target = '8.0'

  s.summary      = "一句代码搞定tableView和collectionview的下拉刷新和上拉加载更多"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "Zhoushaowen" => "348345883@qq.com" }

  s.source       = { :git => "https://github.com/zhoushaowen/SWBasePagingQueryModel.git", :tag => s.version }
  
  s.source_files  = "SWBasePagingQueryModel/SWBasePagingQueryModel/*.{h,m}"
  
  s.requires_arc = true

  s.dependency 'MJRefresh'
  s.dependency 'ReactiveObjC'



end