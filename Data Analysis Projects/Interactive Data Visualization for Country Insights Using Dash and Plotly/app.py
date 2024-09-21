# Import packages
import pandas as pd
import dash
from dash import dcc, html
from dash.dependencies import Output, Input
import plotly.express as px
import dash_bootstrap_components as dbc
import dash_daq as daq
import plotly.graph_objs as go


df = pd.read_csv("D:/Github/Jupyter notebooks/World Happiness Score_Interactive Dashboard/WHR_combined.csv")

app = dash.Dash(__name__)

app.layout = dbc.Container([
    html.Div(className='app-header', 
             children=[
                 html.H1("The State of Happiness and Well-being Worldwide", 
                 className='display-3'),
                 html.H3("Global Well-being: How People are Doing from 2015 to 2023",
                 className='display-3')
                 ]
             ),
    dbc.Row([
        html.Div(className='dropdown-container',
                 children=[
                     dbc.Col(
                         dcc.Dropdown(
                             id="year-dropdown",
                             options=[
                                 {'label': year, 'value':year} 
                                    for year in df['year'].unique()
                                ],
                             value= df['year'].unique().tolist(),
                             style={'width':'300px'},
                             placeholder='Please select a Year'

                         ), width='auto'
                     ),
                     dbc.Col(
                        dcc.Dropdown(
                            id="metric-dropdown",
                            options=[
                              {'label': 'Happiness Index Score', 'value':'happiness_score'},
                                {'label': 'GDP per Capita', 'value':'gdp_per_capita'},
                                {'label': 'Social Support Index', 'value':'social_support'},
                                {'label': 'Healthy Life Expectancy', 'value':'healthy_life_expectancy'},
                                {'label': 'Freedom Of Life Choices', 'value':'freedom_to_make_life_choices'},
                                {'label': 'Generosity', 'value':'generosity'},
                                {'label': 'Perceptions Of Corruption', 'value':'perceptions_of_corruption'},
                            ],
                          style={'width':'300px'},
                         placeholder='Please select a metric'
                         ), width='auto'
                     )
                ],style={'width':'100%',
                         'display': 'inline-flex', 
                         'align-items': 'left'
                        }
            )       
    ]),
    dbc.Row([
       html.Div(className='col1',
                children=[
                    dbc.Col(
                     html.Div(
                      className='map-graph',
                         children = [
                             dcc.Graph(id='world-map')]
                    )
                    )
                 ]
                ),
         html.Div(className='col2', children=[
        dbc.Col([
            html.Div(
                className='insights-column',
                children = [
                    dbc.Row([html.H2("Brief insight by year")]),
                    dbc.Row([html.Div(id='data-insights',className='insight-row')]),
                    dbc.Row([
                        dbc.Col(html.Div(id='top-countries',className='rank-column')),
                        dbc.Col(html.Div(id='bottom-countries',className='rank-column'))
                        ]
                        )
                ]
            )        
        ]
        )])]),
    dbc.Row([
        html.Div(className='col1',children=[
        dbc.Col(html.Div(
            className='line-chart',
            children=[
            dcc.Graph(
                id='country-chart'
                )
            ]
            )
         )
        ]
        ),
        html.Div(
            className='col2',
            children=[
                dbc.Col(html.Div(className='gauge-countryinsights',
                                 children=[
                    dbc.Row(
                        html.Div(
                            className='gauge-chart',
                            children=[
                            daq.Gauge(id='country-world', # type: ignore
                                        showCurrentValue=True,
                                        units="Score"
                                    )
                            ]
                        )
                    ),
                    dbc.Row([html.H3(id='country-insights')])])
                )
            ]
        )
        ])

], fluid=True)

# Creating callbacks (flask Route)
# Map callback
@app.callback(
    Output('world-map', 'figure'),
    [Input('metric-dropdown','value'), Input('year-dropdown', 'value')]
)
#Creating a Funtion to update the map with metric and year once chosen from the drop box
def update_map(selected_metric, selected_years):
   
    # Creating a condition if selected year is none to avoid errors in isin function
    if selected_years is None or not selected_years:
        selected_years = df['year'].unique().tolist()  # Use all available
    selected_years = [selected_years] if isinstance(selected_years, int) else selected_years
    filtered_df = df[df['year'].isin(selected_years)]
   
    # Define titles to make the tile dynamic corresponding to the selected metric
    titles = {'happiness_score': 'Where People are the happiest',
              'gdp_per_capita': 'Where People are the Wealthiest',
              'social_support': 'Where People Feel the Most Supported',
              'healthy_life_expectancy': 'Where People Live the Longest',
              'freedom_to_make_life_choices': 'Where People Enjoy the Most Freedom',
              'generosity': 'Where People are the Most Generous',
              'perceptions_of_corruption': 'Where People Trust the Government the Most'
              }
   
    # Set the title based on the selected metric
    title = titles.get(selected_metric, f"Select a Year and a Metric to visualize How People Thrive Around the World")
    
    # Creating the map 
    fig = px.choropleth(
        filtered_df,
        locations = "country",
        locationmode='country names',
        color= selected_metric,
        hover_name="country",
        color_continuous_scale=px.colors.sequential.Rainbow_r,
        title= title,
        #basemap_visible= True,
        labels= {'happiness_score': 'Happiness meter',
              'gdp_per_capita': 'Wealth meter',
              'social_support': 'Social Support meter',
              'healthy_life_expectancy': 'Life Expectancy meter',
              'freedom_to_make_life_choices': 'Freedom of Choice meter',
              'generosity': 'Generousity meter',
              'perceptions_of_corruption': 'Perception of Corruption meter'}
    )
    fig.update_layout(margin={"r":20,"t":40,"l":0,"b":20})
    fig.update_layout(
    title={
        'font': {
            'family': "'Times New Roman', Times, serif",
            'size': 20,
            'color': "black"
        },
        'x': 0  # Left the title
     }
    )       
    return fig

# The insights
@app.callback(
    Output('data-insights', 'children'),
    [Input('metric-dropdown','value'), Input('year-dropdown', 'value')]
)
#Creating a Funtion to update the insights blocks with metric and year once chosen from the drop box
def update_insights(selected_metric, selected_years):
    # Creating a condition if selected year is none to avoid errors in isin function
    if selected_years is None:
        selected_years = []
    selected_years = [selected_years] if isinstance(selected_years, int) else selected_years
    filtered_df = df[df['year'].isin(selected_years)]
    # Check if the filtered DataFrame is empty
    if filtered_df.empty:
        return [html.H3(f"Please Select a metric and a year to get the insights")]
    
    # Check if the selected metric is a valid column
    if selected_metric not in filtered_df.columns:
        return [html.H3(f"Please Select a metric to get the insights")]
   
    highest = filtered_df.loc[filtered_df[selected_metric].idxmax()]
    lowest = filtered_df.loc[filtered_df[selected_metric].idxmin()]

    new_metric_name = {'happiness_score': 'Happiness Score',
              'gdp_per_capita': 'GDP per Capita',
              'social_support': 'Social Support',
              'healthy_life_expectancy': 'Healthy Life Expectancy',
              'freedom_to_make_life_choices': 'Freedom to make life choice',
              'generosity': 'Generosity',
              'perceptions_of_corruption': 'Perceptions of corruption'
              }
    # Set the metric name based on the selected metric
    selected_metric_title = new_metric_name.get(selected_metric,selected_metric)
    insights = [
        html.H3(f"In {selected_years}, {highest['country']} had the highest {selected_metric_title} with a value of {highest[selected_metric]:.2f} while {lowest['country']} had the lowest {selected_metric_title} with a value of {lowest[selected_metric]:.2f},"),
    ]
    return insights

# Create Top Countires callback
@app.callback(
    Output('top-countries','children'),
    [Input('metric-dropdown','value'), Input('year-dropdown', 'value')]
)
def update_top_countries(selected_metric, selected_years):

    if selected_years is None:
        selected_years = []
    selected_years = [selected_years] if isinstance(selected_years, int) else selected_years
    filtered_df = df[df['year'].isin(selected_years)]
    # Check if the filtered DataFrame is empty
    if filtered_df.empty:
        return [html.H3(f"Please Select a metric and a year to get the Top 10 Countires")]
    
    # Check if the selected metric is a valid column
    if selected_metric not in filtered_df.columns:
        return [html.H3(f"Please Select a metric to get the Top 10 Countires")]
    
    top_countries = filtered_df.nlargest(10, selected_metric)

    top_countries_list = html.Ol([html.Li(f"{row['country']}:{row[selected_metric]:.2f}")
                                  for _, row in top_countries.iterrows()])
    
    return html.Div([
    html.Div([html.H3("Top 10 Countries"),top_countries_list], className='top-bottom-section'),
    ], className='top-bottom-container')                                                       


@app.callback(
    Output('bottom-countries','children'),
    [Input('metric-dropdown','value'), Input('year-dropdown', 'value')]
)
def update_bottom_countries(selected_metric, selected_years):

    if selected_years is None:
        selected_years = []
    selected_years = [selected_years] if isinstance(selected_years, int) else selected_years
    filtered_df = df[df['year'].isin(selected_years)]
    # Check if the filtered DataFrame is empty
    if filtered_df.empty:
        return [html.H3(f"Please Select a metric and a year to get the Bottom 10 Countries")]
    
    # Check if the selected metric is a valid column
    if selected_metric not in filtered_df.columns:
        return [html.H3(f"Please Select a metric to get the Bottom 10 Countries")]
    
    bottom_countries = filtered_df.nsmallest(10, selected_metric)
    bottom_countries_list = html.Ol([html.Li(f"{row['country']}:{row[selected_metric]:.2f}")
                                  for _, row in bottom_countries.iterrows()])
    return html.Div([
    html.Div([html.H3("Bottom 10 Countries"),bottom_countries_list], className='top-bottom-section')
    ], className='top-bottom-container')

# Click a country and get charts about that country over the year
@app.callback(
    Output('country-chart', 'figure'),
    [Input('world-map', 'clickData'), Input('metric-dropdown', 'value')]
)
def display_country_chart(clickData, selected_metric):
    if clickData is None or selected_metric is None:
        return {'data': [], 'layout': {'title': 'Choose a metric and Click on the map to know how your country<br> doing over the years'}}
    
    country = clickData['points'][0]['location']
    filtered_df = df[df['country'] == country]
    if filtered_df.empty:
        return {
            'data': [],
            'layout': {
                'title': f'No data available for {country}'
            }
        }

    new_metric_name = {'happiness_score': 'Happiness Score',
              'gdp_per_capita': 'GDP per Capita',
              'social_support': 'Social Support',
              'healthy_life_expectancy': 'Healthy Life Expectancy',
              'freedom_to_make_life_choices': 'Freedom to make life choice',
              'generosity': 'Generosity',
              'perceptions_of_corruption': 'Perceptions of corruption'
              }
    # Set the metric name based on the selected metric
    selected_metric_title = new_metric_name.get(selected_metric,selected_metric)
    
    fig = px.line(
            filtered_df,
            x='year' ,
            y= selected_metric,
            title= f'{selected_metric_title} for {country} over the Years',
            markers=True,

    )
    fig.update_layout(margin={"r":0,"t":0,"l":0,"b":0})
    # Update y-axis to start from 0
    fig.update_layout(yaxis=dict(range=[0, filtered_df[selected_metric].max() * 1.1]))
    fig.update_layout(legend=dict(orientation="h",yanchor="bottom",y=1.02,xanchor="right",x=1))
    fig.update_yaxes(title_text=selected_metric_title)
    fig.update_layout(
    title={
        'font': {
            'family': "'Times New Roman', Times, serif",
            'size': 24,
            'color': "black"
        },
        'x': 0  # Left the title
     }
    )       
    # Add a trend line based on the mean of the selected metric
    mean_metric = df.groupby('year')[selected_metric].mean()
    fig.add_trace(
        go.Scatter(
            x=mean_metric.index,
            y=mean_metric.values,
            mode='lines',
            name='Wolrd Average',
            line=dict(dash='dash', color='red')
        )
    )
    return fig


# Click a country and get pie chart about that country position to the world
@app.callback(
    Output('country-world', 'value'),
    Output('country-world', 'label'),
    Output('country-world', 'max'),
    Output('country-world', 'min'),
    Output('country-world', 'color'),
    [Input('world-map', 'clickData'), Input('metric-dropdown', 'value'), Input('year-dropdown', 'value')]
)
def update_gauge(clickData, selected_metric, selected_years):
    if clickData is None or selected_metric is None or selected_years is None:
        return 0,'Choose a metric, a year and Click on the map to know how your country doing',10,0,{"gradient":True,"ranges":{"red":[0,10 * 0.3],"yellow":[10 * 0.3,10 * 0.6],"green":[10 * 0.6,10]}}
    
    country = clickData['points'][0]['location']
    selected_year = [selected_years] if isinstance(selected_years, int) else selected_years

    filtered_df = df[(df['country'] == country) & (df['year'].isin(selected_year))]
    if filtered_df.empty:
        return 0, 'No Data', 10, 0, {"gradient":True,"ranges":{"red":[0,10 * 0.3],"yellow":[10 * 0.3,10 * 0.6],"green":[10 * 0.6,10]}}
    country_metric = filtered_df[selected_metric].values[0]
    mean_metric = df[df['year'] == selected_years][selected_metric].mean()
    max_metric = df[df['year'] == selected_years][selected_metric].max()

    new_metric_name = {'happiness_score': 'Happiness Score',
              'gdp_per_capita': 'GDP per Capita',
              'social_support': 'Social Support',
              'healthy_life_expectancy': 'Healthy Life Expectancy',
              'freedom_to_make_life_choices': 'Freedom to make life choice',
              'generosity': 'Generosity',
              'perceptions_of_corruption': 'Perceptions of corruption'
              }
    # Set the metric name based on the selected metric
    selected_metric_title = new_metric_name.get(selected_metric,selected_metric)
    title = f'{selected_metric_title} for {country} In {selected_year}'

    color = {"gradient":True,
             "ranges":{
                 "red":[0,max_metric * 0.3],
                 "yellow":[max_metric * 0.3,max_metric * 0.6],
                 "green":[max_metric * 0.6,max_metric]}}
    
    return country_metric, title, max_metric,0,color




# Click a country and get charts about that country over the year
@app.callback(
    Output('country-insights', 'children'),
    [Input('world-map', 'clickData'), Input('metric-dropdown', 'value'), Input('year-dropdown', 'value')]
)
def display_country_insights(clickData, selected_metric, selected_years):
    if clickData is None or selected_metric is None or selected_years is None:
        return [html.H3('Country Insights: please select a country on the map')]

    country = clickData['points'][0]['location']
    filtered_df = df[(df['country'] == country) & (df['year'] == selected_years)]
    if filtered_df.empty:
        return [html.H3(f'No data available for {country}')]

    country_metric = filtered_df[selected_metric].values[0]
    mean_metric = df[df['year'] == selected_years][selected_metric].mean()
    max_metric = df[df['year'] == selected_years][selected_metric].max()

    new_metric_name = {
        'happiness_score': 'Happiness Score',
        'gdp_per_capita': 'GDP per Capita',
        'social_support': 'Social Support',
        'healthy_life_expectancy': 'Healthy Life Expectancy',
        'freedom_to_make_life_choices': 'Freedom to make life choice',
        'generosity': 'Generosity',
        'perceptions_of_corruption': 'Perceptions of corruption'
    }
    selected_metric_title = new_metric_name.get(selected_metric, selected_metric)

    country_insights = [
        html.H3(f"In [{selected_years}], {country} had a {selected_metric_title} score of [{country_metric:.2f}], "
                f"while the average score was [{mean_metric:.2f}] and the highest score was [{max_metric:.2f}].")
    ]

    return country_insights

if __name__=="__main__":
    app.run_server(debug=True)

