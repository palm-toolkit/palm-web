 <@layout.global classStyle="layout-top-nav skin-blue-light">
 	 	
 	<@content.header>

		<#include "headerHome.ftl" />
		
 	</@content.header>
 	
 	<@content.contentWrapper>
 	
 		<div class="row center-content padding-home-content">
 		
			<a href="<@spring.url '/researcher' />" class="col-md-3 col-sm-6 col-xs-12 box-home">
              <div class="info-box">
                <span class="info-box-icon info-box-home-icon bg-yellow"><i class="fa fa-home fa-users"></i></span>
                <div class="info-box-content info-box-home-text">
                  <span class="info-box-number fontsize24">RESEARCHERS</span>
                </div>
              </div>
            </a>         
            
            <a href="<@spring.url '/publication' />" class="col-md-3 col-sm-6 col-xs-12 box-home">
              <div class="info-box">
                <span class="info-box-icon info-box-home-icon bg-green"><i class="fa fa-home fa-file-text-o"></i></span>
                <div class="info-box-content info-box-home-text">
                  <span class="info-box-number fontsize24">PUBLICATIONS</span>
                </div>
              </div>
            </a>
            
            <a href="<@spring.url '/venue' />" class="col-md-3 col-sm-6 col-xs-12 box-home">
              <div class="info-box">
                <span class="info-box-icon info-box-home-icon bg-aqua"><i class="fa fa-home fa-globe"></i></span>
                <div class="info-box-content info-box-home-text">
                  <span class="info-box-number fontsize24">CONFERENCES</span>
                </div>
              </div>
            </a>
            
            <a href="<@spring.url '/circle' />" class="col-md-3 col-sm-6 col-xs-12 box-home">
              <div class="info-box">
                <span class="info-box-icon info-box-home-icon bg-aqua"><i class="fa fa-home fa-circle-o"></i></span>
                <div class="info-box-content info-box-home-text">
                  <span class="info-box-number fontsize24">CIRCLES</span>
                </div>
              </div>
            </a>
            
          </div>
          		
 	</@content.contentWrapper>
 	
</@layout.global>