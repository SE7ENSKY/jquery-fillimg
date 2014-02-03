###! jquery-fillimg 2.2.2 http://github.com/Se7enSky/jquery-fillimg###
###
@name jquery-fillimg
@description div > img filler
@version 2.2.2
@author Se7enSky studio <info@se7ensky.com>
###

plugin = ($) ->
	createPositionImageFn = ($img, $container) ->
		->
			if not $img.data 'ratio'
				ratio = $img.width() / $img.height()
				return if not ratio
				$img.data 'ratio', ratio

			originalImageAspectRatio = $img.data 'ratio'
			
			hposition = $img.data 'hposition'

			# console.log hposition

			# containerWidth = $(window).width()
			# containerHeight = $(window).height()
			containerWidth = $container.width()
			containerHeight = $container.height()
			containerAspectRatio = containerWidth / containerHeight

			# console.log containerWidth, containerHeight, containerAspectRatio, originalImageAspectRatio

			if containerAspectRatio < originalImageAspectRatio
				$img.css
					width: "#{containerHeight * originalImageAspectRatio}px"
					height: "#{containerHeight}px"
					marginLeft: switch hposition
						when "left" then 0
						when "right" then "#{-1 * (containerHeight * originalImageAspectRatio - containerWidth)}px"
						else "#{-1 * (containerHeight * originalImageAspectRatio - containerWidth) / 2}px"
					marginTop: 0
			else
				$img.css
					width: "#{containerWidth}px"
					height: "#{containerWidth / originalImageAspectRatio}px"
					marginLeft: 0
					marginTop: "#{-1 * (containerWidth / originalImageAspectRatio - containerHeight) / 2}px"

	$.fn.fillimg = ->
		$.each @, ->
			$(@).css
				position: "absolute"
				left: 0
				top: 0
				height: "100%"
				width: "100%"
				overflow: "hidden"
			$img = $(@).find("> *")
			$img.css
				visibility: "hidden"
			positionImageFn = createPositionImageFn $img, $(@)
			# $(@).on 'resized', positionImageFn
			$img.bind 'load', positionImageFn
			$(window).on "resize orientationchange", positionImageFn
			$(document).on "heightChanged", positionImageFn
			setTimeout =>
				positionImageFn()
				$img.css visibility: "visible"
			, 1

		@ # chaining

# UMD 
if typeof define is 'function' and define.amd then define(['jquery'], plugin) else plugin(jQuery)
