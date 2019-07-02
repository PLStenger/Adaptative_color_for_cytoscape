# Adaptative_color_for_cytoscape
Adapt the color of your Gene Ontology from the REVIGO .xgmml file for Cytoscape.

Using the `.xgmml` file from REVIGO is usefull for GO network representation with Cytoscape software. But REVIGO attributes directly an HEX color code for node. This hue color is basicaly red, but the saturation and darkness aren't the same for all the nodes (eg the GOs). Indeed, more the node (GO) is "important" in your result, more the hue is saturated, less is "important", more the hue is darked. With Cytoscape you can directly change the color (in `style` and `Fill color`), but the `.xgmml` file from REVIGO  as already this information and you can't change the color with the software. 

Ex: `<graphics type="ELLIPSE" x="-151.722" y="-60.523" fill="#ff3e3e"/>`. 

If you delete this line of the `.xgmml` file from REVIGO, you can now change the color with Cytoscape. But you loose the information about the "importance" of your GO.

So the idea here, is to extract the HEX color code (`fill="#ff3e3e"`=red) for all nodes, convert it in to RGB color code (`rgb(255, 62, 62)`=red), than convert it into HSV color code (`hsv(0, 0.7568627, 1)`=red). Then you can change only the `hue` value (`0` for `red`, `0.15` for `yellow`, `0.35` for `green`), in order to don't change the saturation and darkness value. Then reconvert the HSV color code (`hsv(0.15, 0.7568627, 1)`=yellow) into RGB color code (`rgb(255, 236, 62)`=yellow). Then, reinject into the original `.xgmml` file from REVIGO in place of the ancient HEX color code (`fill="#ff3e3e"`).

## CookBook

After running REVIGO (http://revigo.irb.hr/) with your data, go the integrative graph section. Then, download the `.xgmml` file.

![alt tag](https://zupimages.net/up/19/27/zdlb.png)


The only thing you need to upload the file into Cytoscape (after well checking the file is in `.xgmml` extension and not in `.xgmml.txt`), you go to `import`and `Network from file` :

![alt tag](https://zupimages.net/up/19/27/5hd6.png)
