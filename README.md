# parallel_coordinates
**Data Encoding & Prototyping**


This homework is done by Khin Thiri Kyaw and Brighten Jelke. When we started drawing the prototype, there were a few design features that we considered. We primarily used color specifically color hue and color saturation as a way to encode data. We made all the attributes (bars) to be color black. We used varying color saturation for items (lines). When we were choosing the color, we choose dark green because we wanted to have a color that is safe for color blind audience. Using color saturation, the darker the item will be as it goes down to the bottom of the attribute. In that way, we can see more clearly about the trends of different items with varying saturation. The sketch of our prototype is attached below. 



**Implementation & Interaction**

For the final implementation of program, we used the same visual encoding that we used in our prototype. In term of the interactivity, we made the attributes swap by dragging the labels of the attribute that we want to move. We made this choice so that when the users select the items, they can just have the selected region on the attribute. When we swap the places of attributes, the gaps between the attributes are not uniform because we want to give the users an option to freely choose the space between the attributes. In addition, we added a two rectangles in each attribute that sets as a range of items that can be presented in between. For instance, they can increase the gap between the two rectangles on a attribute if they want more items to be shown. Thus, the audience can filter the items that they want to see. 



**Future Improvements**
If have more time, we would implement the feature where users can hover over the item and it shows the values of the items in that attribute. We will give users an option to make the space the attributes evenly spaced even if they swap it. We will try to make our program more time efficient and minimumize the use of for-loops. 
