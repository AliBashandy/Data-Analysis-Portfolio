# Import packages
import pandas as pd
import dash
from dash import dcc, html
from dash.dependencies import Output, Input
import plotly.express as px
import dash_bootstrap_components as dbc
import dash_daq as daq
import plotly.graph_objs as go


df = pd.read_csv(r"D:\Github\Data-Analysis-Portfolio\Data Analysis Projects\Automating Crypto Website API Pull Using Python\Crypto_Status.csv")

app = dash.Dash(__name__)

app.layout = dbc.Container([
    html.Div(className = 'app-header',
             children=[html.Div([
                        html.H1("Cryptocurrency Dashboard",className='display-3'),
                        html.H3("Live Cryptocurrency stats based on Coin Market Cap website", className='display-3')
                        ])
                    ]
                ),
    dbc.Row([
        html.Div(className='filter-container',
            children=[
                dbc.Col(className='dropdown-container', 
                    children=[
                        dcc.Dropdown(
                            id='crypto-dropdown',
                            options=[{'label': name, 'value': name} for name in df['name'].unique()],
                            value = 'Bitcoin'
                        )
                    ]
                ),
                dbc.Col(
                    className='chart-selector', children=[
                        dcc.Tabs(
                            id='chart-tabs',
                            value = 'price-tab',
                            children=[
                                dcc.Tab(label='Price', value='price-tab',
                                        style={'height': '40px','padding': '8px', 'border-radius':'8px', 'margin':'0px 2.5px', 'background-color': 'white', 'border': '2px solid lightgray' },
                                        selected_style={'height': '40px','padding': '8px', 'border-radius':'8px', 'margin':'0px 2.5px','border': '2px solid rgb(25 250 123)', 'background-color': 'honeydew'}, 
                                        ),
                                dcc.Tab(label='Market Cap', value='marketcap-tab',
                                        style={'height': '40px','padding': '8px', 'border-radius':'8px', 'margin':'0px 2.5px', 'background-color': 'white' , 'border': '2px solid lightgray'},
                                        selected_style={'height': '40px','padding': '8px', 'border-radius':'8px', 'margin':'0px 2.5px','border': '2px solid rgb(25 250 123)', 'background-color': 'honeydew'}, 
                                    )
                            ]
                        )
                    ]
                ),
                dbc.Col(
                    className='time-filter', children=[
                        dcc.Tabs(
                            id='duration-tabs',
                            value = '1h-tab',
                            children=[
                                dcc.Tab(label='Last Hour', value='1h-tab',
                                        style={'height': '40px','padding': '8px', 'border-radius':'8px', 'margin':'0px 2.5px', 'background-color': 'white', 'border': '2px solid lightgray' },
                                        selected_style={'height': '40px','padding': '8px', 'border-radius':'8px', 'margin':'0px 2.5px','border': '2px solid #1975FA', 'background-color': 'aliceblue'}, 
                                        ),
                                dcc.Tab(label='Last Day', value='1D-tab',
                                        style={'height': '40px','padding': '8px', 'border-radius':'8px', 'margin':'0px 2.5px', 'background-color': 'white' , 'border': '2px solid lightgray'},
                                        selected_style={'height': '40px','padding': '8px', 'border-radius':'8px', 'margin':'0px 2.5px','border': '2px solid #1975FA', 'background-color': 'aliceblue'}, 
                                        ),
                                dcc.Tab(label='Last Week', value='7D-tab',
                                        style={'height': '40px','padding': '8px', 'border-radius':'8px', 'margin':'0px 2.5px', 'background-color': 'white', 'border': '2px solid lightgray' },
                                        selected_style={'height': '40px','padding': '8px', 'border-radius':'8px', 'margin':'0px 2.5px','border': '2px solid #1975FA', 'background-color': 'aliceblue'}, 
                                        ),
                                dcc.Tab(label='Last Month', value='30D-tab',
                                        style={'height': '40px','padding': '8px', 'border-radius':'8px', 'margin':'0px 2.5px', 'background-color': 'white' , 'border': '2px solid lightgray'},
                                        selected_style={'height': '40px','padding': '8px', 'border-radius':'8px', 'margin':'0px 2.5px','border': '2px solid #1975FA', 'background-color': 'aliceblue'}, 
                                        ),
                                dcc.Tab(label='Last Year', value='1y-tab',
                                        style={'height': '40px','padding': '8px', 'border-radius':'8px', 'margin':'0px 2.5px', 'background-color': 'white', 'border': '2px solid lightgray' },
                                        selected_style={'height': '40px','padding': '8px', 'border-radius':'8px', 'margin':'0px 2.5px','border': '2px solid #1975FA', 'background-color': 'aliceblue'}, 
                                        )
                            ]
                        )
                    ]
                )
            ]
        )
    ]),
    dbc.Row([
        html.Div(className='analysis-container',
                 children=[
            dbc.Col(
                className='crypto-stats',
                    children=[
                    dbc.Row(className='stats-row',children=[html.H3('Currency Symbol:'),html.Div(id='currency-symbol',className='metrics_rows')]),
                    dbc.Row(className='stats-row',children=[html.H3('Currency Current Rank:'),html.Div(id='cmc-rank',className='metrics_rows')]),
                    dbc.Row(className='stats-row',children=[html.H3('Current Price:'),html.Div(id='quote-Price',className='metrics_rows')]),
                    dbc.Row(className='stats-row',children=[html.H3('Price Change 1D:'),html.Div(id='percent-change',className='metrics_rows')]),
                    dbc.Row(className='stats-row',children=[html.H3('Market Cap Price: '),html.Div(id='marketcap-Price',className='metrics_rows')]),
                    dbc.Row(className='stats-row',children=[html.H3('Market Cap Dominance:'),html.Div(id='marketcap-dominance',className='metrics_rows')]),
                    dbc.Row(className='stats-row',children=[html.H3('Market Cap Diluted:'),html.Div(id='marketcap-diluted',className='metrics_rows')]),
                    dbc.Row(className='stats-row',children=[html.H3('Market Volume 24h:'),html.Div(id='market-volume',className='metrics_rows')]),
                    dbc.Row(className='stats-row',children=[html.H3('Market Volume Change 1D:'),html.Div(id='volume-change',className='metrics_rows')]),
                    dbc.Row(className='stats-row',children=[html.H3('Total Supply:'),html.Div(id='total-supply',className='metrics_rows')])
                    ]
            ),
            dbc.Col(className='chart-display',
                    children= [
                    dcc.Graph(id='chart')
                    ]
                ),
            dbc.Col(
                html.Div(
                    className='crypto-list',
                    children= [
                        dbc.Row([html.H4("Top 20 by Market Cap Dominanace"),
                                html.Div(id='currency-list',className='list-column')]
                            ),
                    ]
                )
            )
        ])
    ])

])

@app.callback(
    [Output('chart', 'figure')],
    [Input('crypto-dropdown', 'value'), 
     Input('duration-tabs', 'value'), 
     Input('chart-tabs', 'value')]
)
def update_charts(selected_crypto, selected_duration, selected_chart):

    # Defining function for the duration tabs
    def tabs_filter(df,tab):
         # Convert time_stamp to datetime
        df['time_stamp'] = pd.to_datetime(df['time_stamp'])
        # Get the current time
        now = pd.Timestamp.now()
        if tab=='1h-tab':
            duration_period= now -pd.Timedelta(hours=1)
        elif tab == '1D-tab':
            duration_period = now -pd.Timedelta(hours=24)
        elif tab == '7D-tab':
            duration_period = now -pd.Timedelta(days=7)
        elif tab == '30D-tab':
            duration_period = now -pd.Timedelta(days=30)
        elif tab == '1y-tab':
            duration_period = now -pd.DateOffset(years=1)
        return df[df['time_stamp'] >= duration_period]
    
    filtered_df = tabs_filter(df,selected_duration)

    if selected_crypto is None or not selected_crypto:
        filtered_df = filtered_df[filtered_df['name']== 'Bitcoin']
    elif selected_crypto:
        filtered_df = filtered_df[filtered_df['name'] == selected_crypto]

    if selected_chart == 'price-tab':
        chart = px.line(filtered_df, 
                          x='time_stamp', 
                          y='quote.USD.price', 
                          title='Price Over Time',
                          markers = True
                          )
        chart.update_yaxes(title_text='Price USD')
    elif selected_chart == 'marketcap-tab':
         chart = px.line(filtered_df, 
                               x='time_stamp', 
                               y='quote.USD.market_cap', 
                               title='Market Cap Over Time',
                               markers = True,
                               )
         chart.update_yaxes(title_text='Market Cap Price USD')
    chart.update_layout(margin=dict(l=0, r=5, t=35, b=5), hovermode="x")
    chart.update_xaxes(title_text='Date and Time')
    chart.update_traces(mode="markers+lines", hovertemplate=None)
    return [chart] 

@app.callback(
    Output('currency-symbol', 'children'),
    Output('cmc-rank', 'children'),
    Output('quote-Price', 'children'),
    Output('percent-change', 'children'),
    Output('marketcap-Price', 'children'),
    Output('marketcap-dominance', 'children'),
    Output('marketcap-diluted', 'children'),
    Output('market-volume', 'children'),
    Output('volume-change', 'children'),
    Output('total-supply', 'children'),
    [Input('crypto-dropdown', 'value'), 
     Input('duration-tabs', 'value'), 
     Input('chart-tabs', 'value')]
)
def update_stats(selected_crypto, selected_duration, symbol):
    # Defining function for the duration tabs
    def tabs_filter(df,tab):
         # Convert time_stamp to datetime
        df['time_stamp'] = pd.to_datetime(df['time_stamp'])
        # Get the current time
        now = pd.Timestamp.now()
        if tab=='1h-tab':
            duration_period= now -pd.Timedelta(hours=1)
        elif tab == '1D-tab':
            duration_period = now -pd.Timedelta(hours=24)
        elif tab == '7D-tab':
            duration_period = now -pd.Timedelta(days=7)
        elif tab == '30D-tab':
            duration_period = now -pd.Timedelta(days=30)
        elif tab == '1y-tab':
            duration_period = now -pd.DateOffset(years=1)
        return df[df['time_stamp'] >= duration_period]
    
    filtered_df = tabs_filter(df,selected_duration)

    def format_large_numbers(num):
        if num >= 1000000000000:
            return f'{num / 1000000000000:.3f}T'
        elif num >= 1000000000:
            return f'{num / 1000000000:.3f}B'
        elif num >= 1000000:
            return f'{num / 1000000:.3f}M'
        elif num >= 1_000:
            return f'{num / 1000:.3f}K'
        else:
            return f'{num/1:.3f}'

    if selected_crypto is None or not selected_crypto:
        filtered_df = filtered_df[filtered_df['name']== 'Bitcoin']
    elif selected_crypto:
        filtered_df = filtered_df[filtered_df['name'] == selected_crypto]

    filtered_df = filtered_df.sort_values(by='time_stamp')

    symbol = f'[{filtered_df['symbol'].values[-1]}]'

    rank = f'[{filtered_df.iloc[-1]['cmc_rank']:,.0f}]'

    price_formatted = format_large_numbers(filtered_df.iloc[-1]['quote.USD.price'])
    price = f'[${price_formatted}]'

    percent_change = filtered_df.iloc[-1]['quote.USD.percent_change_24h']
    percent_change_color = '#16c784' if percent_change >= 0 else '#ea3943'
    price_arrow = '▲' if percent_change >= 0 else '▼'
    price_change = html.Span(f'[{price_arrow}{percent_change:.2f}%]', style={'color': percent_change_color})

    marketcap_price_formatted = format_large_numbers(filtered_df.iloc[-1]['quote.USD.market_cap'])
    marketcap_price = f'[${marketcap_price_formatted}]'

    mc_dominance_value = filtered_df.iloc[-1]['quote.USD.market_cap_dominance']
    mc_dominance_color = '#16c784' if mc_dominance_value >= 0 else '#ea3943'
    mc_dominance_arrow = '▲' if mc_dominance_value >= 0 else '▼'
    mc_dominance = html.Span(f'[{mc_dominance_arrow}{mc_dominance_value:.2f}%]', style={'color': mc_dominance_color})

    mc_diluted_formatted = format_large_numbers(filtered_df.iloc[-1]['quote.USD.fully_diluted_market_cap'])
    mc_diluted = f'[${mc_diluted_formatted}]'

    market_volume_formatted = format_large_numbers(filtered_df.iloc[-1]['quote.USD.volume_24h'])
    market_volume = f'[${market_volume_formatted}]'

    volume_change_value = filtered_df.iloc[-1]['quote.USD.volume_change_24h']
    volume_change_color = '#16c784' if volume_change_value >= 0 else '#ea3943'
    volume_change_arrow = '▲' if volume_change_value >= 0 else '▼'
    volume_change = html.Span(f'[{volume_change_arrow}{volume_change_value:.2f}%]', style={'color': volume_change_color})

    total_supply_formatted = format_large_numbers(filtered_df.iloc[-1]['total_supply'])
    total_supply = f'[${total_supply_formatted}]'
    return [symbol],[rank],[price],[price_change],[marketcap_price],[mc_dominance],[mc_diluted],[market_volume],[volume_change],[total_supply]


@app.callback(
    [Output('currency-list', 'children')],
    [Input('duration-tabs', 'value')] 
     #Input('chart-tabs', 'value')]
)
def crypto_list(crypto_list):
    
    filtered_df = df.sort_values(by='time_stamp', ascending=False)  
    filtered_df = filtered_df.sort_values(by='cmc_rank').drop_duplicates(subset=['cmc_rank'], keep='last')

    crypto_list = filtered_df.nsmallest(20,'cmc_rank')
    crypto_list_sorted = html.Ol([html.Li(f"{row['name']}:  [{row['quote.USD.market_cap_dominance']:,.2f}%]") 
                                 for _, row in crypto_list.iterrows()])

    return [crypto_list_sorted]
if __name__ == '__main__':
    app.run_server(debug=True)